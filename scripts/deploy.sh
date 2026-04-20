# =============================================================================
# FLUTTER SIDE - Build Commands
# =============================================================================

# Navigate to project
cd /home/windows11/Documents/CryptoMeccaWallet

# Clean and get dependencies
flutter clean
flutter pub get

# Production build with all optimizations
flutter build web \
  --release \
  --tree-shake-icons \
  --wasm \
  --web-renderer skwasm \
  --dart-define=FLUTTER_WEB_USE_SKIA=false \
  --no-source-maps

# Output location
ls -la build/web/

# =============================================================================
# DOCKERFILE - Deploy to Coolify Custom Docker
# =============================================================================

# Build the Docker image locally to test
docker build -t crypto-mecca-wallet:latest .

# Test locally
docker run -d -p 8080:8080 --name crypto-mecca crypto-mecca-wallet:latest

# Check if running
curl http://localhost:8080/health

# Check logs
docker logs crypto-mecca

# Stop and remove
docker stop crypto-mecca && docker rm crypto-mecca

# Tag for registry
docker tag crypto-mecca-wallet:latest zerodayinst/crypto-mecca:latest

# =============================================================================
# ALTERNATIVE: Static Build Pack (if not using Docker)
# =============================================================================

# Build first
flutter build web --release --tree-shake-icons

# The static files are in: build/web/
# Upload contents of build/web/ to Coolify as Static Build Pack
# Set public directory to: .