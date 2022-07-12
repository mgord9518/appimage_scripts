#!/bin/sh
# Grab the newest version of mkappimage
# This should be downloaded and sourced, then `ai_tool` can be used to build AppImages

# Check if user has AppImageTool (under the names of `appimagetool.AppImage`
# and `appimagetool-x86_64.AppImage`) if not, download it
echo 'Checking if AppImageTool is installed...'
if command -v 'mkappimage.AppImage'; then
	ai_tool() {
		'mkappimage.AppImage' "$@"
	}
elif command -v "mkappimage-$ARCH.AppImage"; then
	ai_tool() {
		"mkappimage-$ARCH.AppImage" "$@"
	}
elif command -v "$PWD/mkappimage"; then
	ai_tool() {
		"$PWD/mkappimage" "$@"
	}
elif command -v 'mkappimage'; then
	ai_tool() {
		'mkappimage' "$@"
	}
elif command -v 'appimagetool'; then
	ai_tool() {
		'appimagetool' "$@"
	}
else
	# Hacky one-liner to get the URL to download the latest mkappimage
	mkAppImageUrl=$(curl -q https://api.github.com/repos/probonopd/go-appimage/releases | grep $(uname -m) | grep mkappimage | grep browser_download_url | cut -d'"' -f4 | head -n1)
	echo 'Downloading `mkappimage`'
	wget "$mkAppImageUrl" -O 'mkappimage'
	chmod +x 'mkappimage'
	ai_tool() {
		"$PWD/mkappimage" "$@"
    }
fi
