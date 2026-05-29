FROM ghcr.io/gohugoio/hugo:v0.162.1 AS builder

WORKDIR /src

COPY --chown=1000:1000 . .
USER 1000

RUN ls -la && ls -la content/ && ls -la themes/ && hugo --cacheDir /tmp/hugo-cache --verbose

FROM nginxinc/nginx-unprivileged:stable-alpine

USER 0
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder --chown=101:101 /src/public/ /usr/share/nginx/html/

RUN find /usr/share/nginx/html -type d -exec chmod 755 {} \; && \
    find /usr/share/nginx/html -type f -exec chmod 644 {} \;

USER 101

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]