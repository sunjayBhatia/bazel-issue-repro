Repro:
- On Linux
  - `cd` into this directory
  - run `bazel test --test_output=all //test/...`
  - see the test pass, the `wrapper.sh` script is successfully able to find the test fixture

```
==================== Test output for //test:sh_test_symlinks:
+ echo 'this file: /home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/sandbox/linux-sandbox/17/execroot/sh_test_symlinks/bazel-out/k8-fastbuild/bin/test/sh_test_symlinks.runfiles/sh_test_symlinks/test/sh_test_symlinks'
this file: /home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/sandbox/linux-sandbox/17/execroot/sh_test_symlinks/bazel-out/k8-fastbuild/bin/test/sh_test_symlinks.runfiles/sh_test_symlinks/test/sh_test_symlinks
+ echo 'args: test-fixture'
args: test-fixture
+ echo 'changing into data directory'
changing into data directory
++ dirname /home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/sandbox/linux-sandbox/17/execroot/sh_test_symlinks/bazel-out/k8-fastbuild/bin/test/sh_test_symlinks.runfiles/sh_test_symlinks/test/sh_test_symlinks
+ cd /home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/sandbox/linux-sandbox/17/execroot/sh_test_symlinks/bazel-out/k8-fastbuild/bin/test/sh_test_symlinks.runfiles/sh_test_symlinks/test
+ pwd
/home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/sandbox/linux-sandbox/17/execroot/sh_test_symlinks/bazel-out/k8-fastbuild/bin/test/sh_test_symlinks.runfiles/sh_test_symlinks/test
+ file sh_test_symlinks test-fixture wrapper.sh
sh_test_symlinks: symbolic link to /home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/execroot/sh_test_symlinks/bazel-out/k8-fastbuild/bin/test/sh_test_symlinks
test-fixture:     symbolic link to /home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/execroot/sh_test_symlinks/test/test-fixture
wrapper.sh:       symbolic link to /home/pivotal/.cache/bazel/_bazel_pivotal/cb6e823bfe82d00e98f141b960a1797b/execroot/sh_test_symlinks/test/wrapper.sh
+ ls test-fixture
test-fixture
================================================================================
```

- On Windows
  - ensure `BAZEL_SH` is set to a `bash` shell
  - `cd` into this directory
  - run `bazel test --test_output=all //test/...`
  - see the test fail, the `wrapper.sh` script is not provided a path to itself that it can find the test fixture from
    - it looks instead like it is given a resolved target of the symlink from the runfiles directory of the test

```
==================== Test output for //test:sh_test_symlinks:
+ echo 'this file: C:\u\p\_bazel_pivotal\msdzpxvn\execroot\sh_test_symlinks\bazel-out\x64_windows-fastbuild\bin\test\sh_test_symlinks'
this file: C:\u\p\_bazel_pivotal\msdzpxvn\execroot\sh_test_symlinks\bazel-out\x64_windows-fastbuild\bin\test\sh_test_symlinks
+ echo 'args: test-fixture'
args: test-fixture
+ echo 'changing into data directory'
changing into data directory
++ dirname 'C:\u\p\_bazel_pivotal\msdzpxvn\execroot\sh_test_symlinks\bazel-out\x64_windows-fastbuild\bin\test\sh_test_symlinks'
+ cd 'C:\u\p\_bazel_pivotal\msdzpxvn\execroot\sh_test_symlinks\bazel-out\x64_windows-fastbuild\bin\test'
+ pwd
/c/u/p/_bazel_pivotal/msdzpxvn/execroot/sh_test_symlinks/bazel-out/x64_windows-fastbuild/bin/test
+ file sh_test_symlinks sh_test_symlinks.exe sh_test_symlinks.exe.runfiles sh_test_symlinks.exe.runfiles_manifest
sh_test_symlinks:                       Bourne-Again shell script, ASCII text executable
sh_test_symlinks.exe:                   PE32+ executable (console) x86-64, for MS Windows
sh_test_symlinks.exe.runfiles:          directory
sh_test_symlinks.exe.runfiles_manifest: ASCII text
+ ls test-fixture
ls: cannot access 'test-fixture': No such file or directory
================================================================================
```
