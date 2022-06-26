#!/bin/bash
echo "Download resources"
echo "==================="
git clone https://github.com/sdcilsy/landing-page
git clone https://github.com/sdcilsy/sosial-media
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo apt install -y apache2 php php-mysql mysql-client mysql-server apache2-utils php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip


echo "setting up DB"
echo "====================="
sudo mysql -u root -p -e "create user 'devopscilsy'@'localhost' identified by '1234567890';"
grant all privileges on *.* to 'devopscilsy'@'localhost';
sudo mysql -u root -p -e "create database wp_myblog; create user 'wordpress'@'%' IDENTIFIED WITH mysql_native_password BY '1234567890'; grant all on wp_myblog.* to 'wordpress'@'%';flush privileges;"
sudo mysql -u devopscilsy -p 1234567890 -e "create database dbsosmed;"
sudo mysql -u devopscilsy -p 1234567890 dbsosmed < /var/www/html/dump.sql


echo "Setting up resources"
echo "===================="
sudo rm -f /var/www/html/index.html
cp -r sosial-media/ /var/www/html/socmed/ 
cp -r landing-page/ /var/www/html/landing/
cp -r wordpress/* /var/www/html/wordpress
sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/wp_myblog/g" /var/www/html/wp-config.php
sed -i "s/username_here/wordpress/g" /var/www/html/wp-config.php
sed -i "s/password_here/1234567890/g" /var/www/html/wp-config.php
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo systemctl restart apache2 mysql
sudo systemctl enable apache2 mysql

