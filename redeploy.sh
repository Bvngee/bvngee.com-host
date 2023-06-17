#!/usr/bin/env bash

# Clone website repo if first time, else pull
cd /root
if ! [ -d "/root/bvngeecord.com/.git" ]; then
    git clone https://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@github.com/BvngeeCord/bvngeecord.com/
    cd bvngeecord.com
else
    cd bvngeecord.com
    git pull
fi

# Install deps and packages
npm install
# Make the webroot and clear it
mkdir -p /usr/share/nginx/html && rm -rf /usr/share/nginx/html/*
# Fix potential vulnerabilities
npm audit fix
# Build
npm run build
# Move all contents into webroot folder
cp -r dist/* /usr/share/nginx/html
