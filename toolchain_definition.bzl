load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "flag_group",
    "flag_set",
    "tool"
)
# Link to the source which defines ACTION_NAMES
# https://github.com/bazelbuild/bazel/blob/master/tools/build_defs/cc/action_names.bzl
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

def _cc_toolchain_config_info_generator_impl(ctx):
    manually_linked_shared_library_feature = feature(
        name = "manually_linked_shared_library",
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
    
    features = [
        manually_linked_shared_library_feature,
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
            flag_sets   = [],
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
                                "-r",
                                "%{output_execpath}",
                                "%{libraries_to_link.name}"
                            ],
                            flag_groups = [],
                            iterate_over = "libraries_to_link",
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
