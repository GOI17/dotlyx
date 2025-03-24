args:

with import ../env.nix;

let
  isDarwin = if builtins.currentSystem == "aarch64-darwin" then true else false;
  darwinCfg = import ./mac/silicon/config.nix args;
  linuxCfg = import ./linux/config.nix args;
in if isDarwin then darwinCfg else linuxCfg
