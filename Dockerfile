# Use the official Nginx image as a base
FROM nginx:alpine

# Copy website files to the Nginx public directory
COPY . /usr/share/nginx/html

# Expose port 80 (or use 9000 if you want, see below)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
