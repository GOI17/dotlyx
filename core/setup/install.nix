{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  name = "dotlyx-setup";
  dotfilesBanner = import ./steps/utilities/dotfiles_banner.nix;
  dotfilesLocation = import ./steps/dotfiles_location.nix;
  dotfilesBackup = import ./steps/dotfiles_backup.nix;
  dotfilesInitDefaults = import ./steps/dotfiles_init_defaults.nix;
  script =
  with import ./steps/utilities/colors.nix;
  with import ./steps/utilities/log_helpers.nix;
  writeShellScriptBin name ''
    ${dotfilesBanner.script}
    while getopts "ir:" opt; do
      case ''$opt in
        i) 
          ${dotfilesLocation.script}
          ${dotfilesBackup.script}
          ${dotfilesInitDefaults.script}
          break
          ;;
        r)
          ln -sf ''$USER_DOTFILES_PATH/flake.nix ''$HOME/.config/nix-darwin/flake.nix 
          cd ''$HOME/.config/nix-darwin
          pwd
          if ! $(type darwin-rebuild >/dev/null 2>&1); then
            ${_s "Installing nix-darwin..."}
            nix --extra-experimental-features "nix-command flakes" \
              run nix-darwin -- switch \
              --flake .#dotlyx --impure
          else
            darwin-rebuild switch --flake .#dotlyx --impure
          fi
          break
          ;;
        ?)
          ${_w "Script usage example:"}
        *)
          ${_e "Plase provide a valid option."}
          ;;
      esac
    done

    if [ ''$? -ne 0 ]; then
        ${_e "We stopped the installation. Try with a new installation process"}
        exit 1
    fi

    cd ''$HOME
    ${_s "Restart your terminal and Welcome to Dotlyx!"}
  '';
in stdenv.mkDerivation {
  pname = "Dotlyx";
  version = "0.0.2";
  buildInputs = [
    script
  ];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${script}/bin/${name} $out/bin/${name}
  '';
}
