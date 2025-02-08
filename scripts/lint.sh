#!/bin/bash

set -e

echo "🔍 Running Terraform fmt..."
terraform fmt -recursive

echo "✅ Checking Terraform syntax..."
for dir in environments/* modules/* global/*; do
  if [ -d "$dir" ]; then
    echo "🔍 Validating Terraform in $dir..."
    (cd "$dir" && terraform init -backend=false && terraform validate)
  fi
done

echo "🎉 Terraform linting complete!"
