#!/bin/bash
set -e

# Compile static libraries

# ARM64 Device
scons target=$1 arch=arm64 plugin=appodeal version=$2
# ARM7 Device
scons target=$1 arch=armv7 plugin=appodeal version=$2
# x86_64 Simulator
scons target=$1 arch=x86_64 simulator=yes plugin=appodeal version=$2

# Creating a fat libraries for device and simulator
# lib<plugin>.<arch>-<simulator|ios>.<release|debug|release_debug>.a
lipo -create "./bin/libappodeal.x86_64-simulator.$1.a" \
    "./bin/libappodeal.armv7-ios.$1.a" \
    "./bin/libappodeal.arm64-ios.$1.a" \
    -output "./bin/appodeal.$1.a"
