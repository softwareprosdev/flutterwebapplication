#!/bin/bash

# Crypto Mecca Wallet - Production Build Script
# Optimized for Flutter Web with WebAssembly

set -e

echo "=========================================="
echo "Crypto Mecca - Production Web Build"
echo "=========================================="

# Navigate to project directory
cd /home/windows11/Documents/CryptoMeccaWallet

# Clean previous builds
echo "[1/6] Cleaning previous builds..."
flutter clean

# Get dependencies
echo "[2/6] Getting dependencies..."
flutter pub get

# Build with all optimizations
echo "[3/6] Building production web app..."
flutter build web \
  --release \
  --tree-shake-icons \
  --wasm \
  --web-renderer skwasm \
  --dart-define=FLUTTER_WEB_USE_SKIA=false \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ \
  --no-source-maps

echo "[4/6] Optimizing bundle size..."
# Check build output
ls -la build/web/

echo "[5/6] Creating deployment package..."
# Create deployable archive
cd build/web
tar -czf ../../crypto_mecca_deploy.tar.gz .

echo "[6/6] Build complete!"
echo "Output: build/web/"
echo "Archive: build/crypto_mecca_deploy.tar.gz"

# Show file sizes
echo ""
echo "Bundle sizes:"
du -sh ./
du -sh ./*.wasm 2>/dev/null || true
du -sh ./*.js 2>/dev/null || true
du -sh ./assets/ 2>/dev/null || true
