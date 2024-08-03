{
  lib,
  nix2container,
  dockerTools,
  buildEnv,
  github-readme-stats,

  # note: this could use nodejs slim but then but then it wouldn't
  # be shared as a layer with my other containers that need full nodejs
  nodejs,
  busybox,

  port ? 9000,
  ...
}: nix2container.buildImage {
  name = "bvngee/github-readme-stats";
  tag = "latest";
  maxLayers = 125;
  copyToRoot = [
    dockerTools.caCertificates
    (buildEnv {
      name = "image-root";
      paths = [ busybox ];
      pathsToLink = [ "/bin" ];
    })
  ];
  config = {
    Env = [
      "port=${toString port}"
    ];
    Cmd = [
      ../../util/run_with_secrets.sh
      "PAT_1"
      "\\"
      (lib.getExe nodejs)
      "${github-readme-stats}/lib/node_modules/github-readme-stats/express.js"
    ];
    ExportedPorts."${toString port}/tcp" = {};
  };
}
