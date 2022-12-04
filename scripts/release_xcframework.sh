#!/bin/bash
set -e

# Compile Plugin
./scripts/generate_xcframework.sh release $1
./scripts/generate_xcframework.sh release_debug $1
mv ./bin/appodeal.release_debug.xcframework ./bin/appodeal.debug.xcframework

# Move to release folder
rm -rf ./bin/release
mkdir ./bin/release

# Move Plugin
mv ./bin/appodeal.{release,debug}.xcframework ./bin/release
cp ./appodeal/appodeal.gdip ./bin/release
