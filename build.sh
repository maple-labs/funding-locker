#!/usr/bin/env bash
set -e

export DAPP_SOLC_VERSION=0.6.11
export DAPP_SRC="contracts"
# export DAPP_STANDARD_JSON="./dev.json"

dapp --use solc:0.6.11 build