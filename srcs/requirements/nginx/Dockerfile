# Use Debian Buster as the base image
FROM debian:bullseye

# Install Nginx
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the custom Nginx configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

#to test nginx is working
RUN mkdir -p /var/www/html/test
RUN mv /var/www/html/index.nginx-debian.html /var/www/html/test/index.html

# Expose port 9000
EXPOSE 9000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
