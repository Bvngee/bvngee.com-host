{
  nix2container,
  buildEnv,
  github-readme-stats,

  # note: this could use nodejs slim but then but then it wouldn't
  # be shared as a layer with my other containers that need full nodejs
  nodejs,

  port ? 9000,
  ...
}: nix2container.buildImage {
  name = "github-readme-stats";
  tag = "latest";
  maxLayers = 125;
  copyToRoot = buildEnv {
    name = "image-root";
    paths = [ nodejs github-readme-stats ];
    pathsToLink = [ "/bin" "/lib" ];
  };
  config = {
    Env = [
      "port=${toString port}"
    ];
    Cmd = [
      "/bin/node"
      "/lib/node_modules/github-readme-stats"
    ];
    ExportedPorts."${toString port}/tcp" = {};
  };
}
