FROM ghcr.io/gohugoio/hugo:v0.169.0 AS build
WORKDIR /src
COPY --chown=hugo:hugo . .
RUN hugo --minify

FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /src/public /usr/share/nginx/html
RUN touch /tmp/nginx.pid && chown -R nginx:nginx /tmp /usr/share/nginx/html
USER nginx
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
