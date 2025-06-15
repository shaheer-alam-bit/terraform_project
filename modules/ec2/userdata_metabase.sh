#!/bin/bash

# Update the system and install necessary packages and docker
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Install Nginx
amazon-linux-extras enable nginx1
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx

sudo usermod -aG docker ec2-user

docker pull metabase/metabase:latest

docker run -d -p 1234:3000 --name metabase metabase/metabase

# Configure Nginx to reverse proxy to the Node.js app
cat <<EOF | sudo tee /etc/nginx/conf.d/metabase.conf
server {
    listen 80;
    server_name metabase-bi.azizullahkhan.tech;

    location / {
        proxy_pass http://127.0.0.1:1234;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Restart Nginx
sudo nginx -t && sudo systemctl restart nginx

# Wait for DNS propagation
sleep 180

echo "Setup completed successfully!"