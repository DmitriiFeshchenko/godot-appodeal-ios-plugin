#!/bin/bash
set -e

# Compile Plugin
./scripts/generate_xcframework.sh release $1
./scripts/generate_xcframework.sh release_debug $1
mv ./bin/Appodeal.release_debug.xcframework ./bin/Appodeal.debug.xcframework

# Move Plugin to release folder
rm -rf ./bin/release
mkdir ./bin/release
mv ./bin/Appodeal.{release,debug}.xcframework ./bin/release
cp ./appodeal/Appodeal.gdip ./bin/release
