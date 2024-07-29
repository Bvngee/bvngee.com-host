{
  nix2container,
  dockerTools,
  buildEnv,

  nginx,
  ...
}: nix2container.buildImage {
  name = "bvngee.com-proxy";
  tag = "latest";
  maxLayers = 125;
  copyToRoot = [
    (buildEnv
      {
        name = "image-root";
        paths = [ nginx ];
        pathsToLink = [ "/bin" ];
      })
    dockerTools.fakeNss
  ];
  config = {
    Cmd = [
      "/bin/nginx"
      "-g"
      "\"daemon off;\""
    ];
    Volumes."/usr/share/nginx/html" = { };
    Volumes."/usr/share/nginx/certs" = { };
    ExportedPorts."80/tcp" = {};
    ExportedPorts."443/tcp" = {};
  };
}
