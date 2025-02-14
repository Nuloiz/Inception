# Use Debian Buster as the base image
FROM debian:bullseye

# Install Nginx
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install OpenSSL
RUN apt update && apt install -y openssl

#Only for testing
RUN apt-get update && apt-get install -y curl

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate NOTE localhost has to be replaced with the nschutz.42.fr
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=localhost"

# Copy the custom Nginx configuration file
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Expose port 9000
EXPOSE 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
