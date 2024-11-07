#!/bin/sh

# The purpose of this script is to prevent nginx from starting if the ssl certificate
# files specified in its configuration are not present (which is considered a configuration 
# parsing error).

if [ ! -e /usr/share/nginx/certs/key.pem ] || [ ! -e /usr/share/nginx/certs/fullchain.pem ]; then
    echo "INFO: SSL certificate files not found - waiting for acme.sh to comlete ACME challenges!"
    inotifywait -m -e close_write /usr/share/nginx/certs
    echo "INFO: New SSL certificate files detected!"
fi

reload_on_certs_or_config_change() {
    inotifywait -q -e close_write -m /usr/share/nginx/certs /etc/nginx \
        | while read -r file _event; do \
            echo "INFO: Detected change to ${file}, reloading Nginx..."
            nginx -c /etc/nginx/nginx.conf -s reload \
                && echo "INFO: Successfully reloaded Nginx!" \
                || echo "WARN: Failed to reload Nginx!"
        done
}

echo "INFO: Starting nginx!"

reload_on_certs_or_config_change &

nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
