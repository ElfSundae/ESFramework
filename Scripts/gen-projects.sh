#!/bin/bash
set -euo pipefail

if ! [[ -x "$(command -v xcodegen)" ]]; then
    echo 'Error: XcodeGen is not installed, see https://github.com/yonaskolb/XcodeGen'
    echo 'You may install XcodeGen by running `brew install xcodegen`'
    exit 1
fi

xcodegen

xcodegen -s Example/project.yml
