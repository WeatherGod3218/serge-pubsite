FROM ghcr.io/gohugoio/hugo:v0.162.1 AS builder

WORKDIR /src

COPY --chown=1000:1000 . .
USER 1000

RUN hugo --cacheDir /tmp/hugo-cache

FROM nginxinc/nginx-unprivileged:stable-alpine

USER 0
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder --chown=101:0 /src/public /usr/share/nginx/html
RUN chmod -R g+rwX /var/cache/nginx /var/log/nginx
USER 101

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]