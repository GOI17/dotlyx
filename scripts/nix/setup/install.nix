{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  name = "dotlyx-setup";
  colors = import ./steps/utilities/colors.nix;
  dotfilesBanner = import ./steps/utilities/dotfiles_banner.nix;
  dotfilesLocation = import ./steps/dotfiles_location.nix;
  dotfilesBackup = import ./steps/dotfiles_backup.nix;
  script = with colors; writeShellScriptBin name ''
    ${dotfilesBanner.script}
    ${dotfilesLocation.script}
    ${dotfilesBackup.script}
  '';
in stdenv.mkDerivation {
  pname = "Dotlyx";
  version = "0.0.1";
  buildInputs = [
    script
  ];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${script}/bin/${name} $out/bin/${name}
  '';
}
