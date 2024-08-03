#!/bin/sh

# Clone website repo if first time, else pull. yeet everything 
# if there's conflicts (can technically happen if I do force pushes)
cd /root || exit
if ! [ -d "/root/bvngee.com/.git" ]; then
    git clone https://github.com/Bvngee/bvngee.com
    cd bvngee.com || exit
else
    cd bvngee.com || exit
    git pull || (cd .. \
        && rm -r bvngee.com \
        && git clone https://github.com/Bvngee/bvngee.com \
        && cd bvngee.com || exit)
fi

# Install build deps
npm ci --omit=dev
# Build
npm run build
# Clear old webroot
rm -rf /website-static
# Move new contents into webroot folder
cp -r dist/* /website-static
