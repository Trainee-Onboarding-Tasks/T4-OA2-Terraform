#!/bin/bash

sudo apt update -y
sudo apt install apache2 -y


sudo sed -i 's/Listen 80/Listen 81/' /etc/apache2/ports.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost *:81>/' /etc/apache2/sites-available/000-default.conf

echo "<h1>Proxy Server is Healthy</h1>" | sudo tee /var/www/html/index.html

sudo systemctl restart apache2
sudo systemctl enable apache2