load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "flag_group",
    "flag_set",
    "tool",
    "variable_with_value"
)
# Link to the source which defines ACTION_NAMES
# https://github.com/bazelbuild/bazel/blob/master/tools/build_defs/cc/action_names.bzl
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

def _cc_toolchain_config_info_generator_impl(ctx):
    no_legacy_features_feature = feature(
        name = "no_legacy_features",
        enabled   = True,
        flag_sets = [],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )

    supports_dynamic_linker_feature = feature(
        name = "supports_dynamic_linker",
        enabled   = True,
        flag_sets = [],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )

    # This feature is not used as it appears that it causes all targets to be
    # compiled as position independent code.
    supports_pic_feature = feature(
        name = "supports_pic",
        enabled   = True,
        flag_sets = [],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )

    interpret_as_executable_feature = feature(
        name = "interpret_as_executable",
        enabled   = False,
        flag_sets = [],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )
    
    interpret_as_test_executable_feature = feature(
        name = "interpret_as_test_executable",
        enabled   = False,
        flag_sets = [
            flag_set(
                actions       = [ACTION_NAMES.cpp_link_executable],
                with_features = [],
                flag_groups   = [
                    flag_group(
                        flags = ["-Wl,-rpath,$ORIGIN/%{runtime_library_search_directories}"],
                        flag_groups = [],
                        iterate_over = "runtime_library_search_directories",
                        expand_if_available = "runtime_library_search_directories",
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    )
                ]
            )
        ],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )

    interpret_as_shared_library_feature = feature(
        name = "interpret_as_shared_library",
        enabled   = False,
        flag_sets = [
            flag_set(
                actions       = [ACTION_NAMES.cpp_compile],
                with_features = [],
                flag_groups   = [
                    flag_group(
                        flags = ["-fpic"],
                        flag_groups = [],
                        iterate_over = None,
                        expand_if_available = None,
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    )
                ]
            ),
            # The action is "link executable" as shared library targets are
            # defined with cc_binary.
            flag_set(
                actions       = [ACTION_NAMES.cpp_link_executable],
                with_features = [],
                flag_groups   = [
                    flag_group(
                        flags = ["-shared"],
                        flag_groups = [],
                        iterate_over = None,
                        expand_if_available = None,
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    )
                ]
            )
        ],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )
    
    interpret_as_pic_archive_feature = feature(
        name = "interpret_as_pic_archive",
        enabled   = False,
        flag_sets = [
            flag_set(
                actions       = [ACTION_NAMES.cpp_compile],
                with_features = [],
                flag_groups   = [
                    flag_group(
                        flags = ["-fpic"],
                        flag_groups = [],
                        iterate_over = None,
                        expand_if_available = None,
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    )
                ]
            )
        ],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )

    # This feature is present to allow users to associate cc_library
    # targets with archives. The linkstatic attribute of cc_library is used to
    # ensure that only an archive is produced for the target.
    interpret_as_archive_feature = feature(
        name = "interpret_as_archive",
        enabled   = False,
        flag_sets = [],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )

    libraries_to_link_feature = feature(
        name    = "libraries_to_link",
        enabled = True,
        flag_sets = [
            flag_set(
                actions       = [
                    ACTION_NAMES.cpp_link_executable,
                    ACTION_NAMES.cpp_link_dynamic_library,
                    ACTION_NAMES.cpp_link_nodeps_dynamic_library
                ],
                with_features = [],
                flag_groups   = [
                    flag_group(
                        flags = [
                            "%{user_link_flags}"
                        ],
                        flag_groups = [],
                        iterate_over = "user_link_flags",
                        expand_if_available = "user_link_flags",
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    ),
                     flag_group(
                        flags = [
                            "-Wl,--unresolved-symbols=ignore-in-shared-libs"
                        ],
                        flag_groups = [],
                        iterate_over = None,
                        expand_if_available = None,
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    ),
                    flag_group(
                        flags = [
                            "-L%{library_search_directories}"
                        ],
                        flag_groups = [],
                        iterate_over = "library_search_directories",
                        expand_if_available = "library_search_directories",
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    ),
                    flag_group(
                        flags = [],
                        flag_groups = [
                            flag_group(
                                flags = [
                                    "%{libraries_to_link.name}"
                                ],
                                iterate_over = None,
                                expand_if_available = None,
                                expand_if_not_available = None,
                                expand_if_true = None,
                                expand_if_false = None,
                                expand_if_equal = variable_with_value(
                                    name  = "libraries_to_link.type",
                                    value = "object_file"
                                )
                            ),
                            flag_group(
                                flags = [
                                    "-l%{libraries_to_link.name}"
                                ],
                                iterate_over = None,
                                expand_if_available = None,
                                expand_if_not_available = None,
                                expand_if_true = None,
                                expand_if_false = None,
                                expand_if_equal = variable_with_value(
                                    name  = "libraries_to_link.type",
                                    value = "dynamic_library"
                                )
                            ),
                            flag_group(
                                flags = [
                                    "-l:%{libraries_to_link.name}"
                                ],
                                iterate_over = None,
                                expand_if_available = None,
                                expand_if_not_available = None,
                                expand_if_true = None,
                                expand_if_false = None,
                                expand_if_equal = variable_with_value(
                                    name  = "libraries_to_link.type",
                                    value = "versioned_dynamic_library"
                                )
                            ),
                            flag_group(
                                flags = [
                                    "%{libraries_to_link.name}"
                                ],
                                iterate_over = None,
                                expand_if_available = None,
                                expand_if_not_available = None,
                                expand_if_true = None,
                                expand_if_false = None,
                                expand_if_equal = variable_with_value(
                                    name  = "libraries_to_link.type",
                                    value = "static_library"
                                )
                            ),
                        ],
                        iterate_over = "libraries_to_link",
                        expand_if_available = "libraries_to_link",
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    ),
                    flag_group(
                        flags = [
                            "-o",
                            "%{output_execpath}"
                        ],
                        flag_groups = [],
                        iterate_over = None,
                        expand_if_available = "output_execpath",
                        expand_if_not_available = None,
                        expand_if_true = None,
                        expand_if_false = None,
                        expand_if_equal = None
                    ),
                ]
            ),
        ],
        env_sets  = [],
        requires  = [],
        implies   = [],
        provides  = []
    )

    features = [
        no_legacy_features_feature,
        supports_dynamic_linker_feature,
        interpret_as_executable_feature,
        interpret_as_test_executable_feature,
        interpret_as_shared_library_feature,
        interpret_as_pic_archive_feature,
        interpret_as_archive_feature,
        libraries_to_link_feature
    ]

    action_configs = [
        action_config(
            action_name = ACTION_NAMES.cpp_compile,
            enabled   = False,
            tools     = [
                tool(
                    path                   = "/usr/bin/g++",
                    tool                   = None,
                    with_features          = [],
                    execution_requirements = []
                )
            ],
            flag_sets   = [
                flag_set(
                    actions       = [],
                    with_features = [],                    
                    flag_groups   = [
                        flag_group(
                            flags = [
                                "-include",
                                "%{includes}"
                            ],
                            flag_groups = [],
                            iterate_over = "includes",
                            expand_if_available = "includes",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "-MD",
                                "-MF",
                                "%{dependency_file}",
                            ],
                            flag_groups = [],
                            iterate_over = None,
                            expand_if_available = "dependency_file",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "-frandom-seed=%{output_file}"
                            ],
                            flag_groups = [],
                            iterate_over = None,
                            expand_if_available = "output_file",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "-iquote",
                                "%{quote_include_paths}"
                            ],
                            flag_groups = [],
                            iterate_over = "quote_include_paths",
                            expand_if_available = "quote_include_paths",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "-isystem",
                                "%{system_include_paths}"
                            ],
                            flag_groups = [],
                            iterate_over = "system_include_paths",
                            expand_if_available = "system_include_paths",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "-I",
                                "%{include_paths}"
                            ],
                            flag_groups = [],
                            iterate_over = "include_paths",
                            expand_if_available = "include_paths",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "-D",
                                "%{preprocessor_defines}"
                            ],
                            flag_groups = [],
                            iterate_over = "preprocessor_defines",
                            expand_if_available = "preprocessor_defines",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "%{user_compile_flags}",
                            ],
                            flag_groups = [],
                            iterate_over = "user_compile_flags",
                            expand_if_available = "user_compile_flags",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                                "-c", # Stop after assembling object files.
                                "%{source_file}", # Compilation occurs for a
                                                  # single input file at a time.
                                "-o",
                                "%{output_file}"
                            ],
                            flag_groups = [],
                            iterate_over = None,
                            expand_if_available = "source_file",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                    ]
                )
            ],
            implies     = []
        ),
        action_config(
            action_name = ACTION_NAMES.cpp_link_executable,
            enabled   = False,
            tools     = [
                tool(
                    path                   = "/usr/bin/g++",
                    tool                   = None,
                    with_features          = [],
                    execution_requirements = []
                )
            ],
            flag_sets   = [],
            implies     = []
        ),
        action_config(
            action_name = ACTION_NAMES.cpp_link_dynamic_library,
            enabled     = False,
            tools       = [
                tool(
                    path                   = "/usr/bin/g++",
                    tool                   = None,
                    with_features          = [],
                    execution_requirements = []
                )
            ],
            flag_sets   = [],
            implies     = []
        ),
        action_config(
            action_name = ACTION_NAMES.cpp_link_nodeps_dynamic_library,
            enabled     = False,
            tools       = [
                tool(
                    path                   = "/usr/bin/g++",
                    tool                   = None,
                    with_features          = [],
                    execution_requirements = []
                )
            ],
            flag_sets   = [],
            implies     = []
        ),
        action_config(
            action_name = ACTION_NAMES.cpp_link_static_library,
            enabled   = False,
            tools     = [
                tool(
                    path                   = "/usr/bin/ar",
                    tool                   = None,
                    with_features          = [],
                    execution_requirements = []
                )
            ],
            flag_sets   = [
                flag_set(
                    actions       = [],
                    with_features = [],                    
                    flag_groups   = [
                        flag_group(
                            flags = [
                                "-rs",
                                "%{output_execpath}"
                            ],
                            flag_groups = [],
                            iterate_over = None,
                            expand_if_available = None,
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = [
                               "%{user_link_flags}"
                            ],
                            flag_groups = [],
                            iterate_over = "user_link_flags",
                            expand_if_available = "user_link_flags",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                        flag_group(
                            flags = ["%{libraries_to_link.name}"],
                            flag_groups = [],
                            iterate_over = "libraries_to_link",
                            expand_if_available = "libraries_to_link",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        )
                    ]
                )
            ],
            implies     = []
        ),
        action_config(
            action_name = ACTION_NAMES.strip,
            enabled     = False,
            tools       = [
                tool(
                    path                   = "/usr/bin/strip",
                    tool                   = None,
                    with_features          = [],
                    execution_requirements = []
                )
            ],
            flag_sets   = [
                flag_set(
                    actions = [],
                    with_features = [],
                    flag_groups = [
                        flag_group(
                            flags = ["%{stripopts}"],
                            flag_groups = [],
                            iterate_over = "stripopts",
                            expand_if_available = "stripopts",
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        ),
                         flag_group(
                            flags = ["%{input_file}"],
                            flag_groups = [],
                            iterate_over = None,
                            expand_if_available = None,
                            expand_if_not_available = None,
                            expand_if_true = None,
                            expand_if_false = None,
                            expand_if_equal = None
                        )
                    ]
                )
            ],
            implies     = []
        )
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx                             = ctx,
        features                        = features,
        action_configs                  = action_configs,
        artifact_name_patterns          = [],
        cxx_builtin_include_directories = [
            "/usr/lib/gcc/x86_64-linux-gnu/9",
            "/usr/include"
        ],
        toolchain_identifier            = "",
        host_system_name                = "local",
        target_system_name              = "local",
        target_cpu                      = "x86_64",
        target_libc                     = "unknown",
        compiler                        = "unknown",
        abi_version                     = "unknown",
        abi_libc_version                = "unknown",
        tool_paths                      = [],
        make_variables                  = [],
        builtin_sysroot                 = None
        # cc_target_os (private)
    )

cc_toolchain_config_info_generator = rule(
    implementation = _cc_toolchain_config_info_generator_impl,
    attrs          = {},
    provides       = [CcToolchainConfigInfo]
)
