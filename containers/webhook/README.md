This creates a docker image for [webhook](https://github.com/adnanh/webhook) with a docker volume at `/data` in which webhook looks for the file `hooks.json` and any files `hooks.json` refers to. Webhook is also run with the `-template` CLI flag, so the `hooks.json` file is treated as a Go template (see the webhook readme for more info).

The file name `hooks.json` is a configurable default, and the default
port of 9000 is also configurable. An additional extraPackages option is also
provided to install any extra programs needed.
