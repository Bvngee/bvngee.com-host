{
  nix2container,
  buildEnv,
  runCommand,

  acme-sh, # from flake input (or use fetchFromGitHub)
  openssl,
  curl,
  cron,
  bash,
  coreutils,
  ...
}: 
let
  acme-sh-pkg = runCommand "acme-sh-pkg" {} ''
    mkdir -p $out/acme.sh
    # Only include necessary stuff from acme.sh git repo
    cp -r ${acme-sh}/{deploy,dnsapi,notify,acme.sh} $out/acme.sh
  '';
  deps = buildEnv {
    name = "image-root";
    paths = [ cron curl openssl bash coreutils ];
    pathsToLink = [ "/bin" ];
  };
  acmeRenewScript = runCommand "acme-renew.sh" {} ''
    mkdir -p $out/root
    cat ${./acme-renew.sh} > $out/root/acme-renew.sh
  '';
  crontab = runCommand "crontab" {} ''
    mkdir -p $out/etc/crontabs
    cat ${./crontab} > $out/etc/crontabs/root
  '';
in 
nix2container.buildImage {
  name = "acme.sh";
  tag = "latest";
  maxLayers = 125;
  copyToRoot = [
    acme-sh-pkg
    deps
    acmeRenewScript
    crontab
  ];
  config = {
    Cmd = [
      "/bin/cron"
      "-f"
    ];
    Volumes."/bvngee.com-static" = { };
    Volumes."/acme.sh-certs" = { };
  };
}
