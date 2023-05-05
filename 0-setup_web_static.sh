#!/usr/bin/env bash

# Install Nginx if not installed
if ! command -v nginx &> /dev/null
then
    sudo apt-get update
    sudo apt-get install nginx -y
fi

# Create necessary folders
sudo mkdir -p /data/web_static/releases/test
sudo mkdir -p /data/web_static/shared
sudo touch /data/web_static/releases/test/index.html
echo "Hello World" | sudo tee /data/web_static/releases/test/index.html

# Create symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Change ownership to ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx config
sudo sed -i '/^    listen 80 default_server;/a \    location /hbnb_static {\n        alias /data/web_static/current/;\n    }' /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart
