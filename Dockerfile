FROM ghcr.io/gohugoio/hugo:v0.162.1 AS builder

WORKDIR /src

COPY --chown=1000:1000 . .
USER 1000
RUN hugo --cacheDir /tmp/hugo-cache

FROM nginxinc/nginx-unprivileged:stable-alpine

COPY --from=builder /src/public /usr/share/nginx/html

EXPOSE 8080