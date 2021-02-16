# Toolchain target definition
load("//:toolchain_definition.bzl", "cc_toolchain_config_info_generator")

cc_toolchain_config_info_generator(name = "simple_x86_64_linux_config")

filegroup(name = "empty")

cc_toolchain(
    name                    = "simple_x86_64_linux",
    all_files               = "//:empty",
    # ar_files (optional)
    # as_files (optional)
    # compiler (deprecated, optional)
    compiler_files          = "//:empty",
    # compiler_files_without_includes (optional)
    # coverage_files (optional)
    # cpu (deprecated, optional)
    dwp_files               = "//:empty",
    # dynamic_runtime_lib (optional)
    # libc_top (optional)
    linker_files            = "//:empty",
    # module_map (optional)
    objcopy_files           = "//:empty",
    # static_runtime_lib (optional)
    strip_files             = "//:empty",
    supports_header_parsing = False,
    supports_param_files    = False,
    toolchain_config    = "//:simple_x86_64_linux_config",
    # toolchain_identifier (optional)
)

# Information which describes the cc_toolchain target to the general toolchain
# apparatus of Bazel.
toolchain(
    name                   = "simple_x86_64_linux_toolchain",
    exec_compatible_with   = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64"
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64"
    ],
    target_settings        = [],
    toolchain              = "//:simple_x86_64_linux",
    # The toolchain_type attribute is an identifier that is used by a rule,
    # such as cc_binary, to indicate that the rule uses the identified type of
    # toolchain. Rules can use more than one toolchain_type. C++ rules use a
    # single toolchain_type. The name of a toolchain_type is, by convention,
    # always "toolchain_type".
    toolchain_type         = "@bazel_tools//tools/cpp:toolchain_type"
)

# Platform target definition

platform(
    name              = "x86_64_linux_platform",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux"
    ]
)

# Output targets

# A shared library as two targets: a header and the shared library binary.
cc_library(
    name = "shared_library_header",
    deps = [],
    srcs = [],
    hdrs = ["//:shared_library.h"]
)

cc_binary(
    name       = "libshared_library.so",
    deps       = ["//:shared_library_header"],
    srcs       = ["//:shared_library.cc"],
    features   = ["interpret_as_shared_library"],
    linkopts   = ["-Wl,-soname=libshared_library.so"],
    linkstatic = False
)

# A pic archive.
cc_library(
    name       = "pic",
    deps       = [],
    srcs       = [
        "//:pic1.cc",
        "//:pic2.cc"
    ],
    hdrs       = [
        "//:pic1.h",
        "//:pic2.h"
    ],
    features   = ["interpret_as_pic_archive"],
    linkstatic = True
)

# An archive
cc_library(
    name       = "ar",
    deps       = [],
    srcs       = [
        "//:ar1.cc",
        "//:ar2.cc"
    ],
    hdrs       = [
        "//:ar1.h",
        "//:ar2.h"
    ],
    features   = ["interpret_as_archive"],
    linkstatic = True
)

# The eight meaningful dependency relationships for 
# S = {binary, shared library, pic archive, archive} 
# and the binary dependency relationship "A depends on B" where A and B are
# members of S.
#
# An executable which depends on a shared library.
cc_binary(
    name       = "exe_on_so",
    deps       = ["//:shared_library_header"],
    srcs       = [
        "//:exe_on_so.cc",
        "//:libshared_library.so"    
    ],
    features   = ["interpret_as_executable"],
    linkstatic = False,
)

# A test executable which depends on a shared library.
cc_test(
    name       = "test_on_shared_library",
    deps       = ["//:shared_library_header"],
    srcs       = [
        "//:test_on_shared_library.cc",
        "//:libshared_library.so"
    ],
    features   = ["interpret_as_test_executable"],
    linkstatic = False
)

# # A binary which depends on an archive.
# cc_binary(
#     name = "bin_on_ar"
# )

# A shared library which depends on a shared library.
cc_library(
    name = "shared_library_on_shared_library_header",
    deps = [],
    srcs = [],
    hdrs = ["//:shared_library_on_shared_library.h"]
)

cc_binary(
    name       = "libshared_library_on_shared_library.so",
    deps       = [
        "//:shared_library_on_shared_library_header",
        "//:shared_library_header"
    ],
    srcs       = [
        "//:shared_library_on_shared_library.cc",
        "//:libshared_library.so"
    ],
    features   = ["interpret_as_shared_library"],
    linkopts   = ["-Wl,-soname=libshared_library_on_shared_library.so"],
    linkstatic = False
)

# A test on the shared library which depends on a shared library.
cc_test(
    name       = "test_on_shared_library_on_shared_library",
    deps       = [
        "//:shared_library_on_shared_library_header",
    ],
    srcs       = [
        "//:test_on_shared_library_on_shared_library.cc",
        "//:libshared_library_on_shared_library.so",
    ],
    # $$ is an escaped $. This is necessary due to Make variable substitution.
    env        = {"LD_LIBRARY_PATH": "$${ORIGIN}"}, 
    features   = ["interpret_as_test_executable"],
    linkstatic = False
)

# # A shared library which depends on a pic archive (4).
# cc_library(
#     name = "so_on_pic"
# )

# # A pic archive which depends on a shared library (5).
# cc_library(
#     name = "pic_on_so"
# )

# # A pic archive which depends on a pic archive (6).
# cc_library(
#     name = "pic_on_pic"
# )

# # An archive which depends on a shared library (7).
# cc_library(
#     name = "ar_on_so"    
# )

# # An archive which depends on an archive (8).
# cc_library(
#     name = "ar_on_ar"
# )
