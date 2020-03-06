#!/bin/bash

set -ex

echo "this file: $0"
echo "args: $@"

echo "changing into data directory"
cd $(dirname "$0")
pwd
file *

ls "$@"
