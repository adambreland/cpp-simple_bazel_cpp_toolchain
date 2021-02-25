# A Bazel C++ toolchain for building shared libraries and dependent binaries which conform to typical Linux linking practices.

## Introduction
This Bazel workspace defines `//:simple_x86_64_linux_toolchain`. This
toolchain can be used with the standard C++ rules. As the default C++ toolchain
produces libraries and executables which do not conform to typical linking
practices (see, for example, this [issue](https://github.com/bazelbuild/bazel/issues/492)),
`//:simple_x86_64_linux_toolchain` was developed to have the
following features:
* Position-independent code (PIC) is only used for shared libraries and
  PIC archives by default.
* Executables and shared libraries are linked against their direct shared
  library dependencies.
  * The `DT_NEEDED` fields of these outputs hold shared library Bazel target
    names by default. These names are not mangled in some fashion.
  * The toolchain allows a shared library to be defined with a soname using the
    linker option `-Wl,-soname=<library soname>`.
  * Executables and shared libraries are not linked against shared libraries
    which are part of the implementation details of Bazel.
  * Mechanisms such as `DT_RUNPATH` are not used in executables and
    shared libraries by default.
* A library must be exactly one of: shared library, PIC archive, or archive.
* Targets which are defined to use the toolchain can depend on targets which
  should not be built with the toolchain.

## Toolchain system assumptions; toolchain limitations
### Instruction set, operating system, and compiler.
* The toolchain is configured for x86-64 and Linux. It uses `g++`.
* The current include directories assume `g++` version 9. They can be found
  in `//:toolchain_definition.bzl` in list `gcc_system_include_directories`.

### Limitations
This toolchain is intended to be a starting point in the definition of
C++ toolchains which conform to typical Linux linking practices. It is not
intended to be a drop-in replacement for the default C++ toolchain. As it is,
it does not support all C++ rule attribute semantics. The toolchain is
currently used by [as_components](https://github.com/adambreland/cpp-as_components)
for relatively simple build actions.

The `-s` flag for `bazel build` can be used to print build command lines. These
can then be inspected to ensure that a particular target is built correctly by
the toolchain.

#### Notable Bazel features which are not supported
* The toolchain does not vary compilation and linking options for the standard
  Bazel compilation modes: `dbg`, `fastbuild`, and `opt`. If such behavior is
  desired, it can be implemented without modifying the toolchain by specifying
  the desired compilation mode and using instances of the `--copt` and
  `--linkopt` command line build options.

## Using the toolchain
The toolchain is configured to be used with [platforms](https://docs.bazel.build/versions/master/platforms-intro.html).
Toolchain resolution which uses platforms only occurs for C++ rules when the
following `build` flag is enabled:

`--incompatible_enable_cc_toolchain_resolution`

When platforms are used, the definition of a `cc_toolchain_suite` target is not
necessary.

### Simple description of use
Using the toolchain without modification requires a few steps:

1. This repository is registered as an external repository of the local
   repository. For example, `local_repository` may be used if this repository
   was cloned locally.
2. The execution platforms and toolchain are registered in the local
   `WORKSPACE` file as follows (assuming that the external repository is
   accessed with `@simple_bazel_cpp_toolchain`):
   ```
   register_execution_platforms(
       "@local_config_platform//:host",
       "@simple_bazel_cpp_toolchain//:simple_cpp_x86_64_linux_platform"
   )

   register_toolchains(
       "@simple_bazel_cpp_toolchain//:simple_x86_64_linux_toolchain"
   )
   ```
   The use of `@local_config_platform//:host` assumes that remote execution is
   not performed and that the host is an x86-64 Linux system. Also, as
   described above, use of the toolchain requires `g++` and the presence of
   the assumed system include directories.
3. Targets are defined using the rules given in the target definition section
   below.
4. The build flag `--incompatible_enable_cc_toolchain_resolution` is used. For
   example, a `.bazelrc` file may be used to provide this flag.

## Conceptual target types and target definition
The toolchain allows the definition of five kinds of conceptual targets.

1. Shared library
2. Executable
3. Test executable
4. PIC archive
5. Archive

Explanations of the target structure, Bazel attribute values, and features
which are necessary to define targets of these types follow. Also given are
explanations of:
* how to depend on shared libraries which are produced by the toolchain
* how to depend on internal and external targets in `cc_test` targets

### Definition practices for all targets
* Any target which uses the toolchain and which requires compilation or linking
  must be instantiated with the constraint value
  `//nonstandard_toolchain:simple_cpp_toolchain` in its `exec_compatible_with`
  attribute argument list.

### Shared library targets
A shared library target is meant to represent a shared library which is linked
to its direct dependencies and which relies on the proper installation of these
dependencies.

Configuration:
* Rule type: Two targets are defined for each shared library.
  * A `cc_library` target is defined for the shared library header.
  * A `cc_binary` target is defined for the shared library.
* Target names: For shared library `foo`:
  * Header (`cc_library`): A conventional pattern such as `foo_header` is
    suggested.
  * Binary (`cc_binary`): `libfoo.so` or a versioned variant such as
    `libfoo.so.1.0.0`
* Dependencies (`deps`): The `cc_library` header target.
* Soname (optional): For example, a soname linker option such as
  `-Wl,-soname=libfoo.so.1` may be included in the `linkopts` attribute of the
  `cc_binary` target.
* Feature: `"interpret_as_shared_library"` (for the `cc_binary` target)

Example:
```
cc_library(
    name = "foo_header",
    deps = [],
    srcs = [],
    hdrs = ["foo.h"]
)

cc_binary(
    name                 = "libfoo.so.1.0.0",
    deps                 = [":foo_header"],
    srcs                 = ["foo.cc"],
    linkopts             = ["-Wl,-soname=libfoo.so.1"],
    features             = ["interpret_as_shared_library"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)
```

#### Depending on a shared library
Any target which depends on a shared library which was defined in the way
described above must include the shared library header target in `deps` and the
shared library binary target in `srcs`.

Tests which depend on a versioned shared library which uses a major version
soname must have a target which defines a major version symbolic link to the
shared library in their `data` attribute.

Examples:
```
cc_binary(
    name                 = "bar_on_foo",
    deps                 = [":foo_header"],
    srcs                 = [
        "bar.cc",
        ":libfoo.so.1.0.0"
    ],
    features             = ["interpret_as_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

genrule(
    name     = "libfoo.so.1.0.0_soname_symlink",
    srcs     = [":libfoo.so.1.0.0"],
    outs     = ["libfoo.so.1"],
    # Make variable substitution is used to access the output path.
    cmd_bash = "ln -s libfoo.so.1.0.0 $@"
)

cc_test(
    name                 = "test_on_foo",
    deps                 = [":foo_header"],
    srcs                 = [
        "test_on_foo.cc",
        ":libfoo.so.1.0.0"
    ],
    data                 = [":libfoo.so.1.0.0_soname_symlink"],
    features             = ["interpret_as_test_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)
```

### Executable targets
An executable target is meant to represent an executable program that can be
executed independently of a Bazel installation provided that its shared
library dependencies are properly installed.

Configuration:
* Rule type: `cc_binary`
* Feature: `"interpret_as_executable"`

Example:
```
cc_binary(
    name                 = "executable_target",
    deps                 = [],
    srcs                 = ["executable_target.cc"],
    features             = ["interpret_as_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)
```

### Test executable targets
A test executable target is meant to represent a test which is executed by
Bazel. It is assumed that the test must be able to execute when its shared
library dependencies have not been installed.

Configuration:
* Rule type: `cc_test`
* Shared library dependencies: indirect shared library dependencies are made
  available with `LD_LIBRARY_PATH` as explained below.
* feature: `"interpret_as_test_executable"`

Example without indirect shared library dependencies:
```
cc_test(
    name                 = "test_on_so",
    deps                 = [":so_header"],
    srcs                 = [
        "test_on_so.cc",
        ":libso.so"
    ],
    features             = ["interpret_as_test_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)
```

#### Tests with indirect shared library dependencies
Tests can access their direct shared library dependencies without additional
configuration. Indirect shared library dependencies must be exposed using
the `LD_LIBRARY_PATH` environment variable of the Linux dynamic linker. The
`ORIGIN` token is expanded in the value of `LD_LIBRARY_PATH` to the directory
which contains the test executable. This can be used to describe the
directories which contain the indirect shared library dependencies of the test.

Notes on using `ORIGIN` for this purpose:
* A test which is defined in a package beneath the workspace root can refer
  to targets above its package using the parent directory special symbol `..`.
* Bazel stores external targets within the directory `external` which is
  located at the workspace root. The repository name as defined by
  `local_repository` is used as the root of the repository under `external`.
  The directory structure within a repository directory is the same as the
  structure of the external repository.
* A colon-separated list of directories is accepted for the value of
  `LD_LIBRARY_PATH`.

Example with indirect shared library dependencies:
* `libspam.so` is located at the workspace root.
* `libcram.so` is located at the workspace root and is a dependency of 
  `libspam.so`.
* `libham.so` is located in package `package1` under the workspace root and is
  a dependency of `libspam.so`.
* `libeggs.so` is located in the external repository `external_eggs` at its
  workspace root. It is a dependency of `libspam.so`.
```
cc_library(
    name = "spam_header",
    deps = [],
    srcs = [],
    hdrs = ["spam.h"]
)

cc_binary(
    name                 = "libspam.so",
    deps                 = [
        ":spam_header",
        ":cram_header",
        "//package1:ham_header",
        "@external_eggs//:eggs_header"
    ],
    srcs                 = [
        "spam.cc",
        ":libcram.so",
        "//package1:libham.so",
        "@external_eggs//:libeggs.so"
    ],
    features             = ["interpret_as_shared_library"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

cc_test(
    name                 = "test_with_indirect_so_deps",
    deps                 = [":spam_header"],
    srcs                 = [
        "test_with_indirect_so_deps.cc",
        ":libspam.so"
    ],
    # Use $$ to escape $ and prevent Make variable substitution.
    env                  = {
        "LD_LIBRARY_PATH":
            "$${ORIGIN}:$${ORIGIN}/package1:$${ORIGIN}/external/external_eggs"
    },
    features             = ["interpret_as_test_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)
```

### Archive targets (PIC archive and archive)
Archive targets are intended to represent archives whose sources are not
also directly compiled to shared object files or executables. This assumption
separates library targets into two classes: those which define shared libraries
and those which define static libraries.

PIC archives and archives are defined in the usual way with two additions:
* The `linkstatic` attribute is set to `True` to ensure that a shared library
  is not generated.
* The appropriate feature, either `"interpret_as_pic_archive"` or
  `"interpret_as_archive"`, is used.

Examples:
```
cc_library(
    name                 = "pic_archive",
    deps                 = [],
    srcs                 = ["pic_archive.cc"],
    hdrs                 = ["pic_archive.h"],
    linkstatic           = True,
    features             = ["interpret_as_pic_archive"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

cc_library(
    name                 = "archive",
    deps                 = [],
    srcs                 = ["archive.cc"],
    hdrs                 = ["archive.h"],
    linkstatic           = True,
    features             = ["interpret_as_archive"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)
```

## Building and testing the trial targets
Trial targets are defined which possess various dependency relationships on the
three kinds of targets which can be depended upon (shared library, PIC archive,
and archive). For example, in addition to an executable which depends on a
shared library and a test which depends on a shared library, a test which
depends on a shared library which depends on a shared library is defined.

The command lines which are generated by the toolchain for these targets can
be inspected by using the `-s` flag when executing `bazel build` or 
`bazel test`. For example, `bazel build -s ...` should succeed and print the
command lines which were used for each trial target. 

Several test executables are defined to allow validation of shared library
loading. An execution of `bazel test ...` should pass.

## Additional information on C++ toolchain definition
This section provides a brief explanation of how to define a
C++ toolchain which uses platforms. The main goal of this process is
instantiating a `toolchain` target and registering it in the workspace. This
section may be useful if modifications to this toolchain are desired.

Instantiating `toolchain` for C++ toolchains requires several steps.
A rule must be defined which provides a `CcToolchainConfigInfo` provider
instance. This is done by having the implementation function of the rule return
the result of invoking `cc_common.create_cc_toolchain_config_info` with
object arguments with provide the logic of the toolchain. Defining these
objects is the major activity of defining a toolchain. For example, compilation
and linking command lines are generated by Bazel with the information provided
to `create_cc_toolchain_config_info` in these objects. This toolchain
definition uses `action_config` instead of `tool_path` as `tool_path` is
deprecated. 

The rule is then instantiated in a `BUILD` file. The target created by
instantiating the rule is used in the instantiation of a `cc_toolchain` target.
Finally, the `cc_toolchain` target is used in the instantiation of a
`toolchain` target. To use this non-standard toolchain, the `toolchain` target
must include `//nonstandard_toolchain:simple_cpp_toolchain` in the list
argument of its `exec_compatible_with` attribute.

The following list gives a step-by-step summary of this process for this
toolchain after the custom rule definition step.

Steps:
1. In a `BUILD` file, the rule `cc_toolchain_config_info_generator` is loaded
   from `//:toolchain_definition.bzl`. This rule provides an appropriate
   provider instance for the `toolchain_config` attribute of `cc_toolchain`.
2. The rule is instantiated to define a toolchain configuration target. The
   name of this target conventionally ends with `_config`.
3. A `cc_toolchain` target is instantiated with the appropriate attribute
   values. The value of the `toolchain_config` attribute is set to the
   config target which was instantiated in the previous step.
4. A `toolchain` target is instantiated with:
   * The appropriate `exec_compatible_with` and `target_compatible_with`
     constraint values.
     * For this non-standard toolchain, `exec_compatible_with` must include
       `//nonstandard_toolchain:simple_cpp_toolchain`.
   * As the value of the `toolchain` attribute, the `cc_toolchain` target which
     was instantiated in the previous step.
   * The `toolchain_type` attribute value `@rules_cc//cc:toolchain_type`.

   The name of the `toolchain` target conventionally end with `_toolchain`.
   This target provides the information which is needed by the general
   toolchain mechanism of Bazel to perform platform-based toolchain resolution
   on this toolchain.
5. The execution platforms are registered as described above in "Simple
   description of use".
6. The `toolchain` target is registered in the `WORKSPACE` file with
   `register_toolchains`.
7. Build and test actions use the
   `--incompatible_enable_cc_toolchain_resolution` flag. This flag can be
   provided on the command line or through the use of a `.bazelrc` file.

The `BUILD` and `WORKSPACE` files of this repository serve as examples for this
process.
