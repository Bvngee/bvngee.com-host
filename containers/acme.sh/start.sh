#!/bin/sh

if [ ! -e /acme.sh-certs/key.pem ] || [ ! -e /acme.sh-certs/fullchain.pem ]; then
    echo "INFO: No certs detected after startup, requesting new ones!"
    /root/acme-renew.sh
fi

/bin/cron -n # runs in foreground
