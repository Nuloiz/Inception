# Dockerfile for NGINX
FROM nginx:1.23

# Copy the custom NGINX configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose port 9000
EXPOSE 9000

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
