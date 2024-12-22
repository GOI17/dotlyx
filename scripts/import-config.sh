#!/usr/bin/env bash

nix run .#homeConfigurations.user.activationPackage
echo "Import is done"
