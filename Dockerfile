# =============================================================================
# Crypto Mecca Wallet - Production Dockerfile (Optimized)
# Builds Flutter, serves with Nginx - no root, cached dependencies
# =============================================================================

# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy pubspec first for dependency caching
COPY pubspec.* ./
RUN flutter pub get

# Copy full project
COPY . .

# Production web build
RUN flutter build web --release \
    --dart-define=FLUTTER_WEB_USE_SKIA=false

# Runtime stage - minimal Nginx only
FROM nginx:1.27-alpine

# Remove default nginx site
RUN rm -rf /usr/share/nginx/html/*

# Copy build output
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 3000

CMD ["nginx", "-g", "daemon off;"]