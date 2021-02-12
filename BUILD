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

# Base dependencies for the dependency relationship permutations below.
# Shared library base dependency targets.
directory_path = "/home/adam/cpp/bazel_practice/trial_cpp_platform_config/bazel-bin"
directory_flag = "-L" + directory_path

cc_library(
    name = "so_header",
    deps = [],
    srcs = [],
    hdrs = ["//:so.h"],
)

cc_binary(
    name     = "libso.so",
    deps     = ["//:so_header"],
    srcs     = ["//:so.cc"],
    features = ["manually_linked_shared_library"],
    # linkopts = ["-Wl,-soname=libso.so"]
)

# # A pic archive.
# cc_library(
#     name = "pic"
#     deps = [],
#     srcs = [
#         "//:pic1.cc",
#         "//:pic2.cc"
#     ],
#     hdrs = [
#         "//:pic1.h",
#         "//:pic2.h"
#     ]
# )

# # An archive
# cc_library(
#     name = "ar",
#     deps = [],
#     srcs = [
#         "//:ar1.cc",
#         "//:ar2.cc"
#     ],
#     hdrs = [
#         "//:ar1.h",
#         "//:ar2.h""
#     ] 
# )

# The eight meaningful dependency relationships for 
# S = {binary, shared library, pic archive, archive} 
# and the binary dependency relationship "A depends on B" where A and B are
# members of S.
#
# A binary which depends on a shared library (1).
cc_binary(
    name       = "bin_on_so",
    deps       = ["//:libso.so"],
    srcs       = ["//:bin_on_so.cc"],
    linkopts   = [
        directory_flag,
        "-lso"
    ],
    linkstatic = False
)

cc_test(
    name       = "test_on_so",
    deps       = ["//:libso.so"],
    srcs       = ["//:test_on_so.cc"],
    env        = {"LD_LIBRARY_PATH": directory_path},
    linkopts   = [
        directory_flag,
        "-lso"
    ],
    linkstatic = False
)

# # A binary which depends on an archive (2).
# cc_binary(
#     name = "bin_on_ar"
# )

# # A shared library which depends on a shared library (3).
# cc_library(
#     name       = "so_on_so",
# )

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
