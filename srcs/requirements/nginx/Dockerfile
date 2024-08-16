
FROM nginx:1.23

COPY default.conf /etc/nginx/conf.d/default.conf

COPY nginx.crt /etc/nginx/ssl/nginx.crt
COPY nginx.key /etc/nginx/ssl/nginx.key

COPY html /usr/share/nginx/html
