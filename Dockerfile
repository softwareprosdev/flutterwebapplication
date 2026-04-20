# =============================================================================
# Crypto Mecca Wallet - Production Dockerfile (Fixed)
# =============================================================================

# Build stage - use Flutter base image
FROM dart:3.7.0 AS builder

# Install Flutter (don't run as root)
RUN useradd -m -s /bin/bash builder && \
    mkdir /opt/flutter && \
    chown builder:builder /opt/flutter

USER builder
WORKDIR /opt/flutter

# Clone and setup Flutter
RUN git clone https://github.com/flutter/flutter.git --depth 1 --branch stable . && \
    flutter precache --web

ENV PATH="/opt/flutter/bin:$PATH"

# Go back to app directory
WORKDIR /app
COPY --chown=builder:builder pubspec.yaml ./

# Get dependencies and build
RUN flutter pub get

COPY --chown=builder:builder lib/ ./lib/

RUN flutter build web \
    --release \
    --tree-shake-icons \
    --wasm \
    --web-renderer skwasm \
    --no-source-maps

# Production stage
FROM nginx:1.25-alpine AS production

RUN apk add --no-cache python3

COPY --from=builder /app/build/web /usr/share/nginx/html

COPY default.conf /etc/nginx/conf.d/default.conf

RUN chmod -R 755 /usr/share/nginx/html && \
    chmod +x /usr/local/bin/*

# Support both Coolify ports
EXPOSE 3000 8080

CMD ["nginx", "-g", "daemon off;"]