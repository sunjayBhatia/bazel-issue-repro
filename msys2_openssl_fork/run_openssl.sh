#!/bin/bash

set -ex

openssl version

for i in {1..50}; do
  openssl genrsa -out "${i}_key.pem"
  openssl req -new -key "${i}_key.pem" -out "${i}_cert.csr" -batch -sha256
  echo "passed attempt ${i}"
done
