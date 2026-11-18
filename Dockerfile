FROM ghcr.io/gohugoio/hugo:v0.170.0@sha256:90663d477d1fe08c85643d5752bbf1f4e6391e83f95f85e9942b702649d16cb2 AS build
WORKDIR /src
COPY --chown=hugo:hugo . .
RUN hugo --minify

FROM nginx:alpine@sha256:0563c36f94a6d3ec3584161b77859f740f7e20b4853f52c796a864ce6908e8ea
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /src/public /usr/share/nginx/html
RUN touch /tmp/nginx.pid && chown -R nginx:nginx /tmp /usr/share/nginx/html
USER nginx
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
