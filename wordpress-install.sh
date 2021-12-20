#!/bin/bash
#Author: v-filip
#Wordpress simple install

echo "Welcome to the Wordpress one click installer. First of all, please fill the details below since they're needed to complete the installation."

echo "IMPORTANT: Please ensure that this script is ran by root!"

echo "What's your (system/OS) root password?: "
read ROOTPASSWD

echo "Please create a password for the root of the database: "
read DBROOTPASSWD

#Updates the package list and upgrades all the packages on the system
apt update -y && apt upgrade -y

#Installs the web server, database server and a database client 

apt install apache2 -y

apt install mariadb-server -y

apt install mariadb-client -y

#Installs systemctl

apt install systemctl -y

#Starts the MariaDB daemon

systemctl start mariadb

#Imporves the security of MariaDB
mysql_secure_installation <<EOF

$ROOTPASSWD
y
$DBROOTPASSWD
$DBROOTPASSWD
y
y
y
y
EOF

#Installs PHP and unzip packages
apt install php unzip -y

#Downloads the lastest version of Wordpress
wget https://wordpress.org/latest.zip

#Decompresses the Wordpress that was just downloaded
unzip latest.zip

#Enters into the wordpress directory
cd wordpress

#Copies the contents of the directory to /var/www/html
cp -r * /var/www/html

#Removed the index.html file that was created by default when apache2 was installed
rm -rf /var/www/html/index.html

#Installs the required php modules for this installation
apt install php-mysql php-cgi php-cli php-gd php-curl -y

#Restarts the apache2 daemon
systemctl restart apache2

#Changed the ownership of the /var/www directory
chown -R www-data:www-data /var/www

#Creates a wordpress database
mysql -e "create database wordpress;" --user=root --password=${DBROOTPASSWD}

#Creates a user called "username" whose password is "password"
mysql -e 'create user "username"@"%" identified by "password";' --user=root --password=${DBROOTPASSWD}

#Grants all privileges to the newly created user above
mysql -e 'grant all privileges on wordpress.* to "username"@"%";' --user=root --password=${DBROOTPASSWD}

echo "Done! Enter the host's IP address into your browser of choice and complete the wordpress setup! Good luck!"
echo "NOTE: There is no need to change any details on the second page of the setup since user's called username and password is password"
echo "----------"
echo "Would you like to generate a free SSL cert so your website can support HTTPS? (Enter 1 to proceed): "
echo "----------"
echo "NOTE: First of all, please ensure that you've completed the inital wordpress setup. Once you're able to login, you may answer this."
echo "----------"
read ANSWER

if [ $ANSWER -eq "1" ] 
then
	echo "Please enter your email address: "
	read EMAILADDR

	echo "Please enter your domain name (ex. www.testdomain.com or testdomain.com): "
	read DOMAINNAME
	#Installing certobot which is needed to obtain a LetsEncrypt SSL certificate
	apt install certbot -y

	sleep 1
	#Installing a module that integrates with apache2 web server
	apt install python3-certbot-apache -y 

	sleep 1

	echo "Please go to your domain provider and poit an A record to your server's IP address."
	echo "----------"
	echo "Once done, wait a minute or two for the record to propagate."
	echo "----------"
	echo "Additionally, please go to Wordpress > Settings > General > Add your domain name to wordpress address and site address fields. "
	echo "----------"
	echo "Press enter/return to continue"
	read USELESVAR

	#Generating the certificate and confirguring apache to use it
	certbot -d $DOMAINNAME -m $EMAILADDR --apache --agree-tos --non-interactive --redirect

else
	echo "No worries, ssl cert can always be generated and added later on!"
fi
