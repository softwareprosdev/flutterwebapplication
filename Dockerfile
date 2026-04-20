# =============================================================================
# Crypto Mecca Wallet - Production Dockerfile (Fixed)
# =============================================================================

# Build stage - use Flutter base image
FROM dart:3.7.0 AS builder

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git --depth 1 --branch stable /opt/flutter
ENV PATH="/opt/flutter/bin:$PATH"

RUN flutter config set --stable && \
    flutter precache --web

WORKDIR /app

COPY pubspec.yaml ./
RUN flutter pub get

COPY lib/ ./lib/

# Build Flutter web WITHOUT copying assets (assets folder is empty anyway)
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