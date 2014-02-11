#!/usr/bin/env bash
set -e

# Install additional puppet modules before running puppet provisioner.
if [ `puppet module list | grep -c stdlib` == 0 ]; then
  echo "Installing basic puppet modules.";
  puppet module install puppetlabs/stdlib
  
  # exit 0 1
fi

