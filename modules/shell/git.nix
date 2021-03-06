{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
in {
  options.modules.shell.git = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      git
      gitflow
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      gitAndTools.git-absorb
      (mkIf config.modules.shell.gnupg.enable gitAndTools.git-crypt)
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
      "gh/config.yml".source = "${configDir}/gh/config.yml";
    };

    modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
