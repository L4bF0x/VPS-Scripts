#!/bin/sh
# Setup for Digital Ocean (DO)
# Note: DO isn't the best to use if you're up against an org who's got their anti-phishing game up to pro level
# However, great for beginners
# Assuming running as root
echo "~'* Hello beautiful! *'~" # Because it's good to start on a nice note
echo ""
echo "~'* Starting GoPhish et al. setup ..."
echo ""
apt-get update  # To get the latest packages
apt-get install unzip -y # Install unzip package for upcoming GoPhish file
wget https://github.com/gophish/gophish/releases/download/0.7.1/gophish-v0.7.1-linux-64bit.zip # Grab the star of the show
unzip gophish-v0.7.1-linux-64bit.zip # Extract GoPhish binary
apt-get install certbot -y # Install certbot for SSL cert creation
apt-get install ufw -y # Install universal firewall
ufw default deny incoming # Deny all incoming connections
ufw default allow outgoing # Allow all outgoing connections
ufw allow ssh # Allow SSH connections back into your VPS so you don't get locked out
ufw allow 80/tcp # Allow HTTP connections, helps for CertBot
ufw allow 443/tcp # Allow HTTPS connections, for serving phishing pages
echo ""
read -p "~'* What's your domain? (Format: acme.com) : " DOMAIN # Grabbing our domain name
echo ""
read -p "~'* What's your email? : " EMAIL # Grabbing the email to register SSL cert
echo ""
certbot certonly --standalone -d $DOMAIN --agree-tos -m $EMAIL # Running certbot, follow prompt for newsletter
# Once certs are completed successfully, change GoPhish config file for SSL setup
echo "{
	"admin_server": {
		"listen_url": "0.0.0.0:3333",
		"use_tls": true,
		"cert_path": "gophish_admin.crt",
		"key_path": "gophish_admin.key"
	},
	"phish_server": {
		"listen_url": "0.0.0.0:443",
		"use_tls": true,
		"cert_path": "/etc/letsencrypt/live/$DOMAIN/fullchain.pem",
		"key_path": "/etc/letsencrypt/live/$DOMAIN/privkey.pem"
	},
	"db_name": "sqlite3",
	"db_path": "gophish.db",
	"migrations_prefix": "db/db_",
	"contact_address": ""
}" > config2.json
# Backup original config and then replace with new one
mv config.json ORIGINAL_config.json
mv config2.json config.json
