#!/bin/bash

# Compile Plugin
./scripts/generate_static_library.sh release $1
./scripts/generate_static_library.sh release_debug $1
mv ./bin/Appodeal.release_debug.a ./bin/Appodeal.debug.a

# Move Plugin to release folder
rm -rf ./bin/release
mkdir ./bin/release
mv ./bin/Appodeal.{release,debug}.a ./bin/release
cp ./appodeal/Appodeal.gdip ./bin/release
