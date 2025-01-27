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
#
# cd $USER_DOTFILES_PATH
# git init
# echo "DOTLYX: Adding dotlyx as gitsubmodule"
# git -c protocol.file.allow=always submodule add "$HOME/Documents/personal/workspace/dotlyx" modules/dotlyx
# source "$DOTLYX_HOME_PATH/scripts/nix/check_for_required_tools.sh"
# echo "DOTLYX: Installing dotlyx submodules..."
# git submodule update --init --recursive
# cp -r "$DOTLYX_HOME_PATH/dotfiles_template/"* .
# sed -i -e "s|XXX_USER_DOTFILES_PATH_XXX|$USER_DOTFILES_PATH|g" "./modules/nix/flake.nix"
# sed -i -e "s|XXX_USERNAME_XXX|$(whoami)|g" "./modules/nix/flake.nix"
# for symlinks_file in "conf.yaml" "conf.macos.yaml"; do
# 	"$DOTLYX_HOME_PATH/modules/dotbot/bin/dotbot" -d "$DOTLYX_HOME_PATH" -c "./symlinks/$symlinks_file"
# done
# source "$DOTLYX_HOME_PATH/scripts/nix/build_config.sh"
#
# if [ $? -ne 0 ]; then
# 	echo "DOTLYX: We stopped the installation cause of some issues. Try wiht a new installation process"
# 	exit 1
# fi
#
# cd $HOME
# echo "DOTLYX: Restart your terminal and Welcome to Dotlyx!"
