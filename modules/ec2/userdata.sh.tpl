#!/bin/bash

# Install Docker
yum update -y
sudo yum install git -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Install Nginx
amazon-linux-extras enable nginx1
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
sudo usermod -aG docker ec2-user

# Install Node.js
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs

# Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

cd /home/ec2-user

# Create project directory
mkdir -p /home/ec2-user/project

# Clone git repositories (frontend + backend)
cd /home/ec2-user
git clone https://github.com/shaheer-alam-bit/Todo-app-Frontend.git
git clone https://github.com/shaheer-alam-bit/Todo-App-Backend.git
mv Todo-app-Frontend /home/ec2-user/project
mv Todo-App-Backend /home/ec2-user/project

# Set permissions for the project folder
chown -R ec2-user:ec2-user /home/ec2-user/project

sudo sh -c "echo 'DB_NAME=${DB_NAME}' >> /etc/environment"
sudo sh -c "echo 'DB_USERNAME=${DB_USERNAME}' >> /etc/environment"
sudo sh -c "echo 'DB_PASSWORD=${DB_PASSWORD}' >> /etc/environment"
sudo sh -c "echo 'DB_ENDPOINT=${DB_ENDPOINT}' >> /etc/environment"
sudo sh -c "echo 'DB_PORT=${DB_PORT}' >> /etc/environment"

# Reload the environment variables
source /etc/environment

# Create Docker Compose file
cat <<EOF > /home/ec2-user/project/docker-compose.yml

services:
  frontend:
    build:
      context: ./Todo-app-Frontend
    ports:
      - "3000:80"
    networks:
      - todo-network
    depends_on:
      - backend

  backend:
    build:
      context: ./Todo-App-Backend
    ports:
      - "5000:5000"
    environment:
      DB_NAME: ${DB_NAME}
      DB_USERNAME: ${DB_USERNAME}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_ENDPOINT: ${DB_ENDPOINT}
      DB_PORT: ${DB_PORT}
    networks:
      - todo-network

networks:
  todo-network:
    driver: bridge
EOF

cd /home/ec2-user/project
docker-compose up --build -d

# Remove or disable default nginx config
sudo rm -f /etc/nginx/conf.d/default.conf
sudo rm -f /etc/nginx/sites-enabled/default

# Configure Nginx to reverse proxy to the Node.js app
cat <<EOF | sudo tee /etc/nginx/conf.d/todoapp.conf
server {
    listen 80;
    server_name todoapp.azizullahkhan.tech;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:5000/api/;
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