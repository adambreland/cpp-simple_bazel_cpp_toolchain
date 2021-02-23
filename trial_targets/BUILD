# Output targets. The numbers in the comments indicate the sequence positions
# of the conceptual targets. There are 17 conceptual targets and 22 target
# instantiations. This is due to the use of two targets instantiations for each
# conceptual shared library target.

# A shared library as two targets: a header and the shared library binary.
# 1
cc_library(
    name = "shared_library_header",
    deps = [],
    srcs = [],
    hdrs = ["shared_library.h"]
)

cc_binary(
    name                 = "libshared_library.so",
    deps                 = [":shared_library_header"],
    srcs                 = ["shared_library.cc"],
    features             = ["interpret_as_shared_library"],
    linkopts             = ["-Wl,-soname=libshared_library.so"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A pic archive.
# 2
cc_library(
    name                 = "pic",
    deps                 = [],
    srcs                 = [
        "pic1.cc",
        "pic2.cc"
    ],
    hdrs                 = [
        "pic1.h",
        "pic2.h"
    ],
    features             = ["interpret_as_pic_archive"],
    linkstatic           = True,
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# An archive.
# 3
cc_library(
    name                 = "ar",
    deps                 = [],
    srcs                 = [
        "ar1.cc",
        "ar2.cc"
    ],
    hdrs                 = [
        "ar1.h",
        "ar2.h"
    ],
    features             = ["interpret_as_archive"],
    linkstatic           = True,
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# An executable which depends on a shared library.
# 4
cc_binary(
    name                 = "exe_on_shared_library",
    deps                 = [":shared_library_header"],
    srcs                 = [
        "exe_on_shared_library.cc",
        ":libshared_library.so"    
    ],
    features             = ["interpret_as_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A test executable which depends on a shared library.
# 5
cc_test(
    name                 = "test_on_shared_library",
    deps                 = [":shared_library_header"],
    srcs                 = [
        "test_on_shared_library.cc",
        ":libshared_library.so"
    ],
    features             = ["interpret_as_test_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# An executable which depends on an archive.
# 6
cc_binary(
    name                 = "exe_on_ar",
    deps                 = [":ar"],
    srcs                 = ["exe_on_ar.cc"],
    features             = ["interpret_as_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A test executable which depends on an archive.
# 7
cc_test(
    name                 = "test_on_ar",
    deps                 = [":ar"],
    srcs                 = ["test_on_ar.cc"],
    features             = ["interpret_as_test_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A shared library which depends on a shared library.
# 8
cc_library(
    name = "shared_library_on_shared_library_header",
    deps = [],
    srcs = [],
    hdrs = ["shared_library_on_shared_library.h"]
)

cc_binary(
    # This shared library is versioned to test the toolchain's handling of
    # versioned shared libraries.
    name                 = "libshared_library_on_shared_library.so.1.0.0",
    deps                 = [
        ":shared_library_on_shared_library_header",
        ":shared_library_header"
    ],
    srcs                 = [
        "shared_library_on_shared_library.cc",
        ":libshared_library.so"
    ],
    features             = ["interpret_as_shared_library"],
    linkopts             = ["-Wl,-soname=libshared_library_on_shared_library.so.1"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# Creates the soname symlink for libshared_library_on_shared_library.so.1.0.0.
# The output is used in the data attribute of
# //:test_on_shared_library_on_shared_library.
genrule(
    name     = "libshared_library_on_shared_library.so.1.0.0_soname_symlink",
    srcs     = [":libshared_library_on_shared_library.so.1.0.0"],
    outs     = ["libshared_library_on_shared_library.so.1"],
    cmd_bash = "ln -s libshared_library_on_shared_library.so.1.0.0 $@"
)

# A test on the shared library which depends on a shared library.
# 9
cc_test(
    name                 = "test_on_shared_library_on_shared_library",
    deps                 = [":shared_library_on_shared_library_header"],
    srcs                 = [
        "test_on_shared_library_on_shared_library.cc",
        ":libshared_library_on_shared_library.so.1.0.0",
    ],
    data                 = [":libshared_library_on_shared_library.so.1.0.0_soname_symlink"],
    # $$ is an escaped $. This is necessary due to Make variable substitution.
    env                  = {"LD_LIBRARY_PATH": "$${ORIGIN}"}, 
    features             = ["interpret_as_test_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A shared library which depends on a pic archive.
# 10
cc_library(
    name = "shared_library_on_pic_header",
    deps = [],
    srcs = [],
    hdrs = ["shared_library_on_pic.h"]
)

cc_binary(
    name                 = "libshared_library_on_pic.so",
    deps                 = [
        ":shared_library_on_pic_header",
        ":pic"
    ],
    srcs                 = ["shared_library_on_pic.cc"],
    features             = ["interpret_as_shared_library"],
    linkopts             = ["-Wl,-soname=libshared_library_on_pic.so"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A pic archive which depends on a shared library.
# 11
cc_library(
    name                 = "pic_on_shared_library",
    deps                 = [":shared_library_header"],
    srcs                 = [
        "pic_on_shared_library.cc",
        ":libshared_library.so"
    ],
    hdrs                 = ["pic_on_shared_library.h"],
    features             = ["interpret_as_pic_archive"],
    linkstatic           = True,
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A shared library on the pic archive which depends on a shared library.
# 12
cc_library(
    name = "shared_library_on_pic_on_shared_library_header",
    deps = [],
    srcs = [],
    hdrs = ["shared_library_on_pic_on_shared_library.h"]
)

cc_binary(
    name                 = "libshared_library_on_pic_on_shared_library.so",
    deps                 = [
        ":shared_library_on_pic_on_shared_library_header",
        ":pic_on_shared_library"
    ],
    srcs                 = ["shared_library_on_pic_on_shared_library.cc"],
    features             = ["interpret_as_shared_library"],
    linkopts             = ["-Wl,-soname=libshared_library_on_pic_on_shared_library.so"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A pic archive which depends on a pic archive.
# 13
cc_library(
    name                 = "pic_on_pic",
    deps                 = [":pic"],
    srcs                 = ["pic_on_pic.cc"],
    hdrs                 = ["pic_on_pic.h"],
    features             = ["interpret_as_pic_archive"],
    linkopts             = ["-pthread"], # Unnecessary link option to track inclusion.
    linkstatic           = True,
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A shared library which depends on the pic archive which depends on a pic
# archive.
# 14
cc_library(
    name = "shared_library_on_pic_on_pic_header",
    deps = [],
    srcs = [],
    hdrs = ["shared_library_on_pic_on_pic.h"]
)

cc_binary(
    name                 = "libshared_library_on_pic_on_pic.so",
    deps                 = [
        ":shared_library_on_pic_on_pic_header",
        ":pic_on_pic"
    ],
    srcs                 = ["shared_library_on_pic_on_pic.cc"],
    features             = ["interpret_as_shared_library"],
    linkopts             = ["-Wl,-soname=libshared_library_on_pic_on_pic.so"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# An archive which depends on a shared library.
# 15
cc_library(
    name                 = "ar_on_shared_library",
    deps                 = [":shared_library_header"],
    srcs                 = [
        "ar_on_shared_library.cc",
        ":libshared_library.so"],
    hdrs                 = ["ar_on_shared_library.h"],
    features             = ["interpret_as_archive"],
    linkstatic           = True,
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# A test which depends on the archive which depends on a shared library.
# 16
cc_test(
    name                 = "test_on_ar_on_shared_library",
    deps                 = [":ar_on_shared_library"],
    srcs                 = ["test_on_ar_on_shared_library.cc"],
    features             = ["interpret_as_test_executable"],
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)

# An archive which depends on an archive.
# 17
cc_library(
    name                 = "ar_on_ar",
    deps                 = [":ar"],
    srcs                 = ["ar_on_ar.cc"],
    hdrs                 = ["ar_on_ar.h"],
    features             = ["interpret_as_archive"],
    linkstatic           = True,
    exec_compatible_with = ["//nonstandard_toolchain:simple_cpp_toolchain"]
)
