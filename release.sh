#!/usr/bin/env bash
set -e

while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
    esac
done

echo $version

./build.sh -c ./config/prod.json

rm -rf ./package
mkdir -p package

echo "{
  \"name\": \"@maplelabs/funding-locker\",
  \"version\": \"${version}\",
  \"description\": \"Funding Locker Artifacts and ABIs\",
  \"author\": \"Maple Labs\",
  \"license\": \"AGPLv3\",
  \"repository\": {
    \"type\": \"git\",
    \"url\": \"https://github.com/maple-labs/funding-locker.git\"
  },
  \"bugs\": {
    \"url\": \"https://github.com/maple-labs/funding-locker/issues\"
  },
  \"homepage\": \"https://github.com/maple-labs/funding-locker\"
}" > package/package.json

mkdir -p package/artifacts
mkdir -p package/abis

cat ./out/dapp.sol.json | jq '.contracts | ."contracts/FundingLockerFactory.sol" | .FundingLockerFactory' > package/artifacts/FundingLockerFactory.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/FundingLockerFactory.sol" | .FundingLockerFactory | .abi' > package/abis/FundingLockerFactory.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/FundingLocker.sol" | .FundingLocker' > package/artifacts/FundingLocker.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/FundingLocker.sol" | .FundingLocker | .abi' > package/abis/FundingLocker.json

npm publish ./package --access public

rm -rf ./package
