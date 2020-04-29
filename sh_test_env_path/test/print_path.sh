#!/bin/bash

set -e

if [[ $PATH = *.:* ]]; then
   echo "found '.' in PATH: $PATH"
else
   echo "did not find '.' in PATH: $PATH"
   exit 1
fi

