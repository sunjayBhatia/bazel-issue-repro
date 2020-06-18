def _batch_execute_rule_windows_path_impl(ctx):
    output = ctx.actions.declare_file("output_windows_path.txt")
    cmd = "echo foo > " + output.path.replace("/", "\\")
    batch_file = ctx.actions.declare_file("script_windows_path.bat")
    ctx.actions.write(
        output = batch_file,
        content = cmd,
    )
    ctx.actions.run(
        # NOTE: Use Windows style path as executable
        executable = batch_file.path.replace("/", "\\"),
        env = {"SOME_ENV_VAR": "some_value"},
        # NOTE: needed to ensure file exists and is available to action
        inputs = [batch_file],
        mnemonic = "BatchExecuteWithWindowsPath",
        outputs = [output],
    )

    return [DefaultInfo(
        files = depset([output]),
    )]

batch_execute_rule_windows_path = rule(
    implementation = _batch_execute_rule_windows_path_impl,
)

def _batch_execute_rule_regular_path_impl(ctx):
    output = ctx.actions.declare_file("output_regular_path.txt")
    cmd = "echo foo > " + output.path.replace("/", "\\")
    batch_file = ctx.actions.declare_file("script_regular_path.bat")
    ctx.actions.write(
        output = batch_file,
        content = cmd,
    )
    ctx.actions.run(
        # NOTE: Use File type for executable, mimics rules_go usage
        executable = batch_file,
        env = {"SOME_ENV_VAR": "some_value"},
        mnemonic = "BatchExecuteWithRegularPath",
        outputs = [output],
    )

    return [DefaultInfo(
        files = depset([output]),
    )]

batch_execute_rule_regular_path = rule(
    implementation = _batch_execute_rule_regular_path_impl,
)

def _batch_print_execution_environment_impl(ctx):
    output = ctx.actions.declare_file("output_execution_environment.txt")
    ctx.actions.run(
        executable = "cmd.exe",
        arguments = ["/S", "/C", "(echo %cd% & echo --- & dir & echo --- & dir C:\ & echo --- & set) > " + output.path.replace("/", "\\")],
        env = {"SOME_ENV_VAR": "some_value"},
        mnemonic = "BatchPrintExecutionEnvironment",
        outputs = [output],
    )

    return [DefaultInfo(
        files = depset([output]),
    )]

batch_print_execution_environment = rule(
    implementation = _batch_print_execution_environment_impl,
)
