#!/usr/bin/env bash

# Exit when any command fails
set -e

# If acme.sh is not installed or there is no data in the persistent ~/.acme.sh volume, install it and issue certs
if [ ! -f "/root/.acme.sh/acme.sh" ]; then
    echo "No persistent ~/.acme.sh volume detected - Beginning acme.sh install and cert issuing!"

    # Install achme.sh
    curl https://get.acme.sh | sh -s email=nystromjp@gmail.com 
    cd /root/.acme.sh/
    ./acme.sh --upgrade --auto-upgrade

    # Change ownership and permissions of the webroot folder (Not sure if necessary)
    chown -R root:nginx /usr/share/nginx && chmod g+rws /usr/share/nginx

    # Start nginx with the minimal, http-only configuration file (for acme.sh webroot mode)
    nginx -c /etc/nginx/nginx-simple-http.conf

    # Request SSL certs (uses nginx webroot mode)
    ./acme.sh --set-default-ca --server letsencrypt --issue \
        -d bvngeecord.com \
        -d www.bvngeecord.com \
        -d webhook.bvngeecord.com \
        -w /usr/share/nginx/html

    # Kill nginx (will be restarted with main config as fg process)
    nginx -s quit -c /etc/nginx/nginx-simple-http.conf
else
    echo "Detected persistent ~/.acme.sh volume - Must be a rerun, proceeding as normal."
fi

# Install certs to nginx config location
echo "Installing SSL certs to respective Nginx config location."
mkdir -p /usr/share/nginx/certs && rm -f /usr/share/nginx/certs/*
cd /root/.acme.sh/
./acme.sh --install-cert \
    -d bvngeecord.com \
    --key-file /usr/share/nginx/certs/key.pem \
    --fullchain-file /usr/share/nginx/certs/fullchain.pem \
    --reloadcmd "pidof nginx && nginx -s reload || echo 'Nginx not running - cant restart.'"

# Initial website build
echo "Starting initial website build."
/usr/local/bin/redeploy.sh

# Start nginx with main configuration, and start webhook server in the background
/usr/local/bin/webhook -port 3000 -hooks /root/webhook/hooks.json & /usr/sbin/nginx -g "daemon off;"
