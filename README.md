# Appodeal iOS Plugin for Godot GameEngine

*It is not an official Appodeal plugin.*

**This repository contains source code of Appodeal iOS Plugin for Godot engine. If you are looking for an addon itself, follow the first link below.**

## Links:

### [Appodeal Addon for Godot](https://github.com/DmitriiFeshchenko/godot-appodeal-addon)

### [Android Plugin](https://github.com/DmitriiFeshchenko/godot-appodeal-android-plugin)

### [Changelog](CHANGELOG.md)

## Building Instructions:

In case you want to build an iOS plugin yourself (for different Godot Engine or Appodeal SDK versions), follow these steps:

0. If you have extracted engine headers, you can skip steps 1-3, and manually put them into `/headers/godot` directory.

1. Add the desired version of [Godot Engine](https://github.com/godotengine/godot) to the `/godot` folder.

2. Run `./scripts/generate_headers.sh [3.x|4.0]` in terminal to build the Godot Engine header files.

3. Run `./scripts/export_headers.sh` to copy all required headers into `/headers/godot` directory.

4. Download Appodeal iOS SDK fat build archive from the [official website](https://wiki.appodeal.com/en/ios/get-started) and copy the header files from `Appodeal.xcframework` folder into `/headers/appodeal/Appodeal` directory.

5. Run `./scripts/release_xcframework.sh [3.x|4.0]` to build the plugin.

6. Get your plugin from the `/bin/release` directory.
