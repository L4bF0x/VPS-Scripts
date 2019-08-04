#!/bin/sh
apt-get update  # To get the latest packages
apt-get install unzip -y # Install unzip package for upcoming GoPhish file
wget https://github.com/gophish/gophish/releases/download/0.7.1/gophish-v0.7.1-linux-64bit.zip # Grab the star of the show
unzip gophish-v0.7.1-linux-64bit.zip # Extract GoPhish binary
apt-get install certbot -y # Install certbot for SSL cert creation
