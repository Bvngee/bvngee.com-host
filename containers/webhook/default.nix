{
  lib,
  nix2container,
  buildEnv,
  runCommand,
  webhook,

  coreutils,
  nodejs,
  gitMinimal, 

  port ? 3000,
# defaults are specific to my use case
  extraPackages ? [ coreutils nodejs gitMinimal ],
  extraFiles ? [ ./rebuild.sh ],
  hooksFile ? ./hooks.json,
  ...
}: nix2container.buildImage {
  name = "webhook";
  tag = "latest";
  maxLayers = 125;
  copyToRoot = [
    (buildEnv {
      name = "image-root";
      paths = [ webhook ] ++ extraPackages;
      pathsToLink = [ "/bin" ];
    })
    (runCommand "extraFiles" { }
      (lib.concatStringsSep "\n" [
        "mkdir -p $out/root"
        (map (f: "cp -r ${f} /root") extraFiles)
      ])
    )
  ];
  config = {
    Cmd = [
      "/bin/webhook"
      "-port"
      (toString port)
      "-hooks"
      hooksFile
      "-template"
    ];
    Volumes."/bvngee.com-static" = { };
    WorkingDir = "/root";
    ExportedPorts."${toString port}/tcp" = {};
  };
}
