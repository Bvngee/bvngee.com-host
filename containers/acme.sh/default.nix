{
  nix2container,
  dockerTools,
  buildEnv,
  runCommand,

  acme-sh, # from flake input (or use fetchFromGitHub)
  openssl,
  curl,
  cron,
  busybox,
  ...
}: 
let
  acme-sh-pkg = runCommand "acme-sh-pkg" {} ''
    mkdir -p $out/acme.sh
    # Only include necessary stuff from acme.sh git repo
    cp -r ${acme-sh}/{deploy,dnsapi,notify,acme.sh} $out/acme.sh
    chmod -R 755 $out/acme.sh 
    patchShebangs $out/acme.sh 
  '';
  deps = buildEnv {
    name = "image-root";
    paths = [ cron curl openssl busybox ];
    pathsToLink = [ "/bin" ];
  };
  acmeRenewScript = runCommand "acme-renew.sh" {} ''
    mkdir -p $out/root
    ln -s ${./acme-renew.sh} $out/root/acme-renew.sh
  '';
  crontab = runCommand "crontab" {} ''
    mkdir -p $out/etc/crontabs
    ln -s ${./crontab} $out/etc/crontabs/root
  '';
  cronVar = runCommand "cron-var" {} ''
    mkdir -p $out/var/run/ # Needed for cron to create it's pid file
  '';
in 
nix2container.buildImage {
  name = "bvngee/acme.sh";
  tag = "latest";
  maxLayers = 125;
  copyToRoot = [
    acme-sh-pkg
    deps
    dockerTools.caCertificates
    acmeRenewScript
    crontab
    cronVar
  ];
  config = {
    Cmd = [
      ../../util/run_with_secrets.sh
     "CF_Token"
     "CF_Account_ID"
     "\\"
      ./start.sh # Requests certs if that hasn't been done yet; otherwise starts cron
    ];
    Volumes."/bvngee.com-static" = { };
    Volumes."/acme.sh-certs" = { };
  };
}
