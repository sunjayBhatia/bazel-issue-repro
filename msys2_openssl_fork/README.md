### Setup

Copy a GCP credential file for a user with access to RBE into this directory

Run:

```
docker run -it --rm -v <path to this directory>:C:/source gcr.io/envoy-ci/envoy-build-windows:b480535e8423b5fd7c102fd30c92f4785519e33a powershell.exe
```

### Repro

To demonstrate local build succeeds, run:

```
bazel --output_base=C:/_eb test --verbose_failures --keep_going --test_output=all --nocache_test_results ...
```

To demonstrate remote build failure, run:

```
bazel --output_base=C:/_eb test --verbose_failures --keep_going --test_output=all --nocache_test_results --config=remote-msvc-cl --remote_instance_name=<RBE instance name with Windows worker pool> --google_credentials=<path to GCP credential file> ...
```

Example Failure output:

```
FAIL: //:openssl_fork_failure (see C:/_eb/execroot/msys2_openssl_fork/bazel-out/x64_windows-fastbuild/testlogs/openssl_fork_failure/test.log)
INFO: From Testing //:openssl_fork_failure:
==================== Test output for //:openssl_fork_failure:
+ openssl version
OpenSSL 1.1.1g  21 Apr 2020
+ for i in {1..50}
+ openssl genrsa -out 1_key.pem
Generating RSA private key, 2048 bit long modulus (2 primes)
.....................................................................................................................................................................................................+++++
......+++++
e is 65537 (0x010001)
+ openssl req -new -key 1_key.pem -out 1_cert.csr -batch -sha256
+ echo 'passed attempt 1'
passed attempt 1
+ for i in {1..50}
+ openssl genrsa -out 2_key.pem
Generating RSA private key, 2048 bit long modulus (2 primes)
.......+++++
...............................................................+++++
e is 65537 (0x010001)
+ openssl req -new -key 2_key.pem -out 2_cert.csr -batch -sha256
+ echo 'passed attempt 2'
passed attempt 2
+ for i in {1..50}
+ openssl genrsa -out 3_key.pem
Generating RSA private key, 2048 bit long modulus (2 primes)
.........+++++
....................................+++++
e is 65537 (0x010001)
+ openssl req -new -key 3_key.pem -out 3_cert.csr -batch -sha256
+ echo 'passed attempt 3'
passed attempt 3
+ for i in {1..50}
+ openssl genrsa -out 4_key.pem
Generating RSA private key, 2048 bit long modulus (2 primes)
.........................................+++++
....+++++
e is 65537 (0x010001)
+ openssl req -new -key 4_key.pem -out 4_cert.csr -batch -sha256
+ echo 'passed attempt 4'
passed attempt 4
+ for i in {1..50}
+ openssl genrsa -out 5_key.pem
      0 [main] openssl 1087 child_info_fork::abort: \??\C:\tools\msys64\usr\bin\msys-ssl-1.1.dll: Loaded to different address: parent(0x58F950000) != child(0x170000)
+ openssl req -new -key 5_key.pem -out 5_cert.csr -batch -sha256
Can't open 5_key.pem for reading, No such file or directory
34359738384:error:02001002:system library:fopen:No such file or directory:crypto/bio/bss_file.c:69:fopen('5_key.pem','r')
34359738384:error:2006D080:BIO routines:BIO_new_file:no such file:crypto/bio/bss_file.c:76:
unable to load Private Key
================================================================================
Target //:openssl_fork_failure up-to-date:
  bazel-bin/openssl_fork_failure
  bazel-bin/openssl_fork_failure.exe
INFO: Elapsed time: 58.505s, Critical Path: 58.19s
INFO: 3 processes: 1 internal, 2 remote.
INFO: Build completed, 1 test FAILED, 3 total actions
//:openssl_fork_failure                                                  FAILED in 13.4s
```
