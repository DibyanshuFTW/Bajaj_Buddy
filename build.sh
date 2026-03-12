#!/bin/bash
# Install Flutter in Vercel's build environment
echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Build the Web app
echo "Building Flutter Web..."
flutter/bin/flutter build web --release
