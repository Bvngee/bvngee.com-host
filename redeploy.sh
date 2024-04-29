#!/usr/bin/env bash
# shellcheck disable=SC2164

# Clone website repo if first time, else pull
cd /root
if ! [ -d "/root/bvngeecord.com/.git" ]; then
    git clone https://github.com/BvngeeCord/bvngeecord.com/
    cd bvngeecord.com
else
    cd bvngeecord.com
    git pull
fi

# Install deps and packages
npm install
# Make the webroot folder if it dne
mkdir -p /usr/share/nginx/html
# Build
npm run build
# Clear old webroot
rm -rf /usr/share/nginx/html/*
# Move new contents into webroot folder
cp -r dist/* /usr/share/nginx/html
