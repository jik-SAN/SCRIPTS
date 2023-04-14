#!/bin/bash

echo "            *************PASSWORD-*-GENERATOR***************"
read -p "Enter Length of Password : " PASS_LEN

for p in $(seq 1 7); do
  tr -dc 'A-Za-z0-9!"#$%&()*+,-./<=>?@[\]^_{|}' </dev/urandom | head -c $PASS_LEN; echo ""
done
