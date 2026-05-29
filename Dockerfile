FROM ghcr.io/gohugoio/hugo:v0.162.1 AS builder

WORKDIR /src

COPY --chown=1000:1000 . .
USER 1000

RUN hugo --cacheDir /tmp/hugo-cache

FROM nginxinc/nginx-unprivileged:stable-alpine

WORKDIR /usr/share/nginx/html
COPY --from=builder /src/public .
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]