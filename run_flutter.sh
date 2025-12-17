#!/bin/bash
# Flutter WSL runner with Windows browser support
export BROWSER="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
flutter run -d linux "$@"
