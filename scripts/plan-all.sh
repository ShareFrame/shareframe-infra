#!/bin/bash
for env in dev; do
  echo "Running Terraform Plan for $env..."
  cd ../environments/$env
  terraform init
  terraform plan
  cd -
done
