#!/bin/bash

# Compile Plugin
./scripts/generate_static_library.sh release $1
./scripts/generate_static_library.sh release_debug $1
mv ./bin/appodeal.release_debug.a ./bin/appodeal.debug.a

# Move to release folder
rm -rf ./bin/release
mkdir ./bin/release

# Move Plugin
mv ./bin/appodeal.{release,debug}.a ./bin/release
