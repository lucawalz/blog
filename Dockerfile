FROM ghcr.io/gohugoio/hugo:v0.170.1@sha256:4cc9f383086c0fba180efcf7132cf2f025969c462fedf5fcd2bf921915416797 AS build
WORKDIR /src
COPY --chown=hugo:hugo . .
RUN hugo --minify

FROM nginx:alpine@sha256:fb4658584bd9a916ffb6f6e365f97c25cfdb2923801f551ea08356e695f14ff7
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /src/public /usr/share/nginx/html
RUN touch /tmp/nginx.pid && chown -R nginx:nginx /tmp /usr/share/nginx/html
USER nginx
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
