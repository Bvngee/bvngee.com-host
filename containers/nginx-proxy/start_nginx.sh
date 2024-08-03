#!/bin/sh

# The purpose of this script is to prevent nginx from starting if the ssl certificate
# files specified in its configuration are not present (which is considered a configuration 
# parsing error).

if [ ! -e /usr/share/nginx/certs/key.pem ] || [ ! -e /usr/share/nginx/certs/fullchain.pem ]; then
    echo "INFO: SSL certificate files not found - waiting for acme.sh to comlete ACME challenges!"
    inotifywait -m -e close_write /usr/share/nginx/certs
    echo "INFO: New SSL certificate files detected! Starting nginx!"
fi

reload_on_certs_or_config_change() {
    while inotifywait -e close_write -m /usr/share/nginx/certs /etc/nginx; do
        echo "INFO: File change detected - reloading Nginx!"
        nginx -s reload
    done
}

echo "INFO: Starting nginx!"

reload_on_certs_or_config_change &

nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
