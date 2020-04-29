Repro:
- On Linux
  - `cd` into this directory
  - be sure to disable any global `.bazelrc` settings (e.g. `--action_env=PATH` type settings)
  - run `bazel test --test_output=all //test/...` and `bazel test --test_output=all --incompatible_strict_action_env=true //test/...`
  - see the test pass both invocations, the PATH correctly has `.` as an element
  - bash does not by default seem to add a `.` to the front of the PATH (tested via `env -i bash --norc --noprofile -c 'echo $PATH'`)

```
==================== Test output for //test:sh_test_env_path:
found '.' in PATH: .:/bin:/usr/bin:/usr/local/bin
================================================================================
```

- On Windows
  - ensure `BAZEL_SH` is set to a `bash` shell
  - `cd` into this directory
  - be sure to disable any global `.bazelrc` settings (e.g. `--action_env=PATH` type settings)
  - run `bazel test --test_output=all //test/...` and `bazel test --test_output=all --incompatible_strict_action_env=true //test/...`
  - see the test fail both invocations (assuming `.` is not already a PATH element), the PATH does not have `.` as an element

```
==================== Test output for //test:sh_test_env_path:
did not find '.' in PATH: /usr/bin:/usr/bin:/bin:/c/Windows:/c/Windows/System32:/c/Windows/System32/WindowsPowerShell/v1.0
================================================================================
```
