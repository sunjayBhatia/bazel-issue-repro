### Setup

Copy a GCP credential file for a user with access to RBE into this directory

Run:

```
docker run -it --rm -v <path to this directory>:C:/source gcr.io/envoy-ci/envoy-build-windows:f21773ab398a879f976936f72c78c9dd3718ca1e powershell.exe
```

### Repro

To demonstrate local build succeeds, run:

```
bazel --output_base=C:/_eb build --verbose_failures --keep_going ...
```

To demonstrate remote build failure, run:

```
bazel --output_base=C:/_eb build --verbose_failures --keep_going --config=remote-msvc-cl --remote_instance_name=<RBE instance name with Windows worker pool> --google_credentials=<path to GCP credential file> ...
```

Failure output:

```
ERROR: C:/source/BUILD:7:1: Couldn't build file output_regular_path.txt: BatchExecuteWithRegularPath output_regular_path.txt failed (Exit 1): script_regular_path.bat failed: error executing command
  cd C:/_eb/execroot/ctx_actions_run_rbe
  SET SOME_ENV_VAR=some_value
  bazel-out/x64_windows-fastbuild/bin/script_regular_path.bat
Execution platform: @rbe_windows_msvc_cl//config:platform
'bazel-out' is not recognized as an internal or external command,
operable program or batch file.
ERROR: C:/source/BUILD:3:1: Couldn't build file output_windows_path.txt: BatchExecuteWithWindowsPath output_windows_path.txt failed (Exit 1): script_windows_path.bat failed: error executing command
  cd C:/_eb/execroot/ctx_actions_run_rbe
  SET SOME_ENV_VAR=some_value
  bazel-out/x64_windows-fastbuild/bin/script_windows_path.bat
Execution platform: @rbe_windows_msvc_cl//config:platform
'bazel-out' is not recognized as an internal or external command,
operable program or batch file.
```

#### Notes

- `//:batch_execute_rule_windows_path` rule fails even though we have explicitly passed it an executable with a Windows path.
- The verbose failure output printed is not what Bazel literally runs, from some digging, Bazel actually reconstitutes a script representation supposedly equivalent to the commands it runs, see https://github.com/bazelbuild/bazel/blob/2a4c6e335cbfe43d973b6804798002250a8e806d/src/main/java/com/google/devtools/build/lib/util/CommandFailureUtils.java#L91-L126
- The error `'bazel-out' is not recognized as an internal or external command, operable program or batch file.` hints that `cmd.exe` is trying to run `bazel-out` as an executable and the remainder of the path are interpreted as arguments
  - Is this simply an issue with how Bazel is passing paths to `cmd.exe`/quoting issue, strange that it only happens remotely?
- It seems Bazel constructs a command line here, running via `cmd.exe` if the executable does not end in `.exe`: https://github.com/bazelbuild/bazel/blob/2a4c6e335cbfe43d973b6804798002250a8e806d/src/main/java/com/google/devtools/build/lib/util/CommandBuilder.java#L131-L168
- The working directory (`cd <working_directory>`) printed for the remote failures does not seem to exist in the remote execution container
  - This is an interesting thing to note: https://github.com/bazelbuild/bazel/blob/2a4c6e335cbfe43d973b6804798002250a8e806d/src/main/java/com/google/devtools/build/lib/shell/Command.java#L169-L170
  - It appears commands are run via this class, with the working directory being set by https://github.com/bazelbuild/bazel/blob/2a4c6e335cbfe43d973b6804798002250a8e806d/src/main/java/com/google/devtools/build/lib/shell/JavaSubprocessFactory.java#L156
- Same failure (with different paths) occurs when omitting the `--output_base` flag
- See `execution_environment_results/` for output of the `//:batch_print_execution_environment` rule
