This creates a container image (using nix2container) for [webhook](https://github.com/adnanh/webhook). See configuration options extraPackages (added to /bin), extraFiles (added to /root), hooksFile, and port. 

Webhook is also run with the `-template` CLI flag, so the hooksFile is treated as a Go template (see the webhook readme for more info). See https://github.com/adnanh/webhook/blob/master/docs/Templates.md
