FROM hugomods/hugo:nightly AS builder

WORKDIR /app

COPY . .

RUN hugo --minify

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/public .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]