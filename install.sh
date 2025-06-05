#!/bin/bash
set -e  # Exit on any error

# Check if GITHUB_TOKEN exists
if [ -z "$GITHUB_TOKEN" ]; then
   echo "⚠️ ERROR: GITHUB_TOKEN is not configured"
   exit 1
else
   echo "✅ GITHUB_TOKEN detected successfully"
fi

# Configure Git credentials
echo "🔑 Setting up Git credentials..."
export GIT_CREDENTIALS="https://${GITHUB_TOKEN}:x-oauth-basic@github.com"
git config --global credential.helper store
echo "${GIT_CREDENTIALS}" > ~/.git-credentials
echo "✅ Git credentials configured"

# Debug Git config
echo "📝 Current Git config:"
git config --list

# Clone Flutter first
echo "📦 Setting up Flutter..."
if [ -d "flutter" ]; then
   echo "Updating Flutter to version 3.29.2..."
   cd flutter
   git fetch
   git checkout 3.29.2
   cd ..
else 
   echo "Cloning Flutter version 3.29.2..."
   git clone https://github.com/flutter/flutter.git -b 3.29.2
   echo "📱 Flutter version:"
   ./flutter/bin/flutter --version
fi
# Handle submodules before Flutter configuration
echo "🔄 Setting up submodules..."
# Configure Git for submodules
git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

# Initialize and update submodules
echo "Initializing submodules..."
git submodule init
echo "Updating submodules..."
git submodule update --init --recursive --force

# Show submodule status
echo "📊 Submodule Status:"
git submodule status

# List directory structure for debugging
echo "📂 Directory structure:"
# find . -type d -maxdepth 3 -not -path "*/\.*"

# Verify submodules
echo "📂 Checking submodule directories:"
ls -la packages/api || echo "API package not found"
ls -la packages/domain || echo "Domain package not found"

# Now configure Flutter
echo "⚙️ Configuring Flutter..."
./flutter/bin/flutter doctor
./flutter/bin/flutter clean
./flutter/bin/flutter config --enable-web

echo "✅ Installation script completed"

./flutter/bin/flutter build web --profile --no-tree-shake-icons \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL= \
  --dart-define=FLUTTER_WEB_USE_SKIA=true