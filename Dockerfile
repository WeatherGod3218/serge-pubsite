FROM klakegg/hugo:0.161.1-ext AS builder

WORKDIR /app
COPY . .

RUN hugo

FROM nginxinc/nginx-unprivileged:stable-alpine

COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 8080