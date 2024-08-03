#!/bin/sh

port=$1
hooksFile=$2

if [ ! -e /acme.sh-certs/key.pem ] || [ ! -e /acme.sh-certs/fullchain.pem ]; then
    echo "INFO: No website files detected after startup, running rebuild!"
    /root/rebuild.sh
    echo "INFO: Finished initial website build!"
fi

webhook -port "$port" -hooks "$hooksFile" -template
