A nix package definition for the
[github-readme-stats](https://github.com/anuraghazra/github-readme-stats) nodejs
application.

As suggested in the project's readme (Deploy your own -> On other platforms),
this patches github-readme-stats's package.json to add express as a dependency.
This is used by my container image for this service directly.
