#!/usr/bin/env bash
set -e

while getopts t:r:b:v:c: flag
do
    case "${flag}" in
        c) config=${OPTARG};;
    esac
done

config=$([ -z "$config" ] && echo "./config/prod.json" || echo "$config")

# Workaround for the src folder
mv -f lib/ds-test/src lib/ds-test/contracts
mv -f lib/subfactory/lib/ds-test/src lib/subfactory/lib/ds-test/contracts

export DAPP_TEST_TIMESTAMP=1622483493
export DAPP_TEST_NUMBER=12543537
export DAPP_SOLC_VERSION=0.6.11
export DAPP_SRC="contracts"
export DAPP_LINK_TEST_LIBRARIES=0
export DAPP_STANDARD_JSON=$config

dapp --use solc:0.6.11 build

# Workaround for the src folder
mv -f lib/ds-test/contracts lib/ds-test/src
mv -f lib/subfactory/lib/ds-test/contracts lib/subfactory/lib/ds-test/src