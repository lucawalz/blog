FROM ghcr.io/gohugoio/hugo:v0.170.1@sha256:4cc9f383086c0fba180efcf7132cf2f025969c462fedf5fcd2bf921915416797 AS build
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
