# wordpress-install

This script makes it super easy to get started with Wordpress. 

It doesn't matter where you're hosting your VPS instance, with this script you can get wordpress up and running in matter of seconds. 

To get the script, just copy and paste this simple one liner into your CLI. 

     $ wget https://bit.ly/3FovxnC -O wordpress-install.sh && bash wordpress-install.sh

Done, once script finishes, you need enter your the server's IP address to a browser of your choice and complete the wordpress setup.

NOTE: There is no need to change the details on the second page of the setup since user's name is username and password is password. 

Enjoy!

20.12.2021 update: Adding the ability to generate SSL/TLS cert in order to force Wordpress to use HTTPS. Cert is completely free of charge. Thanks LetsEncrypt ;)

Tested on: Debian 10 and Ubuntu 20.04

If you're behind a firewall, make sure to expose incoming port 80 and 443 should you choose to use HTTPS.

20.12.2021 update: Adding the ability to generate SSL/TLS cert in order to force Wordpress to use HTTPS. Cert is completely free of charge. Thanks LetsEncrypt ;)

Prerequisites: 
- You own a domain
- You point a DNS A record to your server's IP address (This can be done through your domain provider's website - procedure will differ depending on your provider but its fairly simple)
- Make sure that your domain is added to Wordpress' Settings under general tab.
