FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN apt update && apt install -y openssl

# Installed for testing purposes
RUN apt-get update && apt-get install -y curl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=nschutz.42.fr"

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
