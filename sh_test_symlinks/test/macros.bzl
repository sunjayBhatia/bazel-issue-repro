def sh_test():
    native.sh_test(
        name = "sh_test_symlinks",
        srcs = ["wrapper.sh"],
        data = ["wrapper.sh", "test-fixture"],
        args = ["test-fixture"],
    )
