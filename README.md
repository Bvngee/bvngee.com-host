# Website Self-hosting Setup

This is everything I use to build and host my website as well as a few other miscellaneous applications (all under *.bvngee.com). 
I package everything using container images that are generated purely using Nix expressions (no Dockerfiles!!) and sent
to my private self-hosted container registry using nix2container (which internally uses a patched version of Skopeo).

This setup is quite elaborate (and arguably overcomplicated). I plan to write a blog post discussing everything
in the future, including my decision making process (I've been meaning to for a while).
