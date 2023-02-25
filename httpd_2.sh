#!/bin/bash

#Install httpd
echo "--------------------yum update and install httpd-------------------------------------"
yum update -y && yum install -y httpd
sleep 2

echo "--------------------systemctl start and enable httpd-------------------------------------"
systemctl start httpd && systemctl enable httpd
sleep 2

#Create domain directory
mkdir -p /var/www/test/html && mkdir -p /var/www/test/log
sleep 2

#Change owner and change mode
chown -R userok:userok /var/www/test/html && chmod -R 755 /var/www
echo "--------------------html first name and last name-------------------------------------"

#Create index.html
echo "<html><body>Illia Korniienko</body></html>" > /var/www/test/html/index.html

#Options in virtual host
echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
echo "<VirtualHost 127.0.0.1:80>" > /etc/httpd/sites-available/test.conf
echo "ServerName www.test" >> /etc/httpd/sites-available/test.conf
echo "ServerAlias test" >> /etc/httpd/sites-available/test.conf
echo "DocumentRoot /var/www/test/html" >> /etc/httpd/sites-available/test.conf
echo "ErrorLog /var/www/test/log/error.log" >> /etc/httpd/sites-available/test.conf
echo "CustomLog /var/www/test/log/requests.log combined" >> /etc/httpd/sites-available/test.conf
echo "</VirtualHost>" >> /etc/httpd/sites-available/test.conf

#Create soft link
ln -s /etc/httpd/sites-available/test.conf /etc/httpd/sites-enabled/test.conf
echo "--------------------httpd -t and reload-------------------------------------"

#Test apache and reload
httpd -t && systemctl reload httpd

#Test domain
echo "127.0.0.1 www.test test" >> /etc/hosts

#Install web browser
yum install -y lynx
lynx www.test

echo "Done script"

