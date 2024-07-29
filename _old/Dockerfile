# Build Webhook via the go+alpine container
FROM golang:alpine AS webhook
RUN go install github.com/adnanh/webhook@2.8.1 # should install to: /go/bin/webhook

# Copy Webhook executable into fresh nginx+alpine container
FROM nginx:mainline-alpine
COPY --from=webhook /go/bin/webhook /usr/local/bin/webhook

# Install build deps + acme.sh deps + Nginx + bash (to make debug easier)
RUN apk add --no-cache nodejs npm git bash openssl curl

# Copy configurations files into container
COPY nginx.conf /etc/nginx/nginx.conf
COPY mime.types /etc/nginx/mime.types
COPY nginx-simple-http.conf /etc/nginx/nginx-simple-http.conf
COPY hooks.json /root/webhook/hooks.json

# Copy redeploy script (pulls source code from GitHub and builds)
COPY redeploy.sh /usr/local/bin/redeploy.sh

COPY init_container.sh /usr/local/bin/init_container.sh
CMD /usr/local/bin/init_container.sh
