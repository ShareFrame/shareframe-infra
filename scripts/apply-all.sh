#!/bin/bash
for env in dev; do
  echo "Applying Terraform Changes to $env..."
  cd ../environments/$env
  terraform apply -auto-approve
  cd -
done
