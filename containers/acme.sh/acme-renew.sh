#!/bin/bash
# Only for use within this acme.sh docker container

pushd /acme.sh || exit

# note: --set-default-ca is only useful for debugging (manually calling acme.sh)
./acme.sh --set-default-ca --server letsencrypt --issue \
    -d bvngee.com \
    -d '*.bvngee.com' \
    -w /bvngee.com-static

./acme.sh --install-cert \
    -d bvngee.com \
    -d '*.bvngee.com' \
    --key-file /acme.sh-certs/key.pem \
    --fullchain-file /acme.sh-certs/fullchain.pem \
