{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  name = "dotlyx-setup";
  version = "0.0.3";
  dotfilesBanner = import ./steps/utilities/dotfiles_banner.nix;
  dotfilesLocation = import ./steps/dotfiles_location.nix;
  dotfilesBackup = import ./steps/dotfiles_backup.nix;
  dotfilesInitDefaults = import ./steps/dotfiles_init_defaults.nix;
  script =
  with import ./steps/utilities/colors.nix;
  with import ./steps/utilities/log_helpers.nix;
  writeShellScriptBin name ''
    while getopts "iruv" flag; do 
      case ''$flag in
        i)
          ${dotfilesBanner.script {} }
          ${dotfilesLocation.script}
          ${dotfilesBackup.script}
          ${dotfilesInitDefaults.script}
          break
          ;;
        r)
          ${dotfilesBanner.script { type = "rebuild"; }}
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
        u)
          cd $DOTLYX_HOME_PATH
          git fetch
          git merge
          git submodule update --init --recursive
          ${_s "Dotlyx core was updated"}
          break
          ;;
        v)
          ${_s "Dotlyx core: ${version}v"}
          break
          ;;
        *)
          ${_e "Invalid option. \n Script usage: \$(basename \$0) [-i][-r][-u][-v]"}
          exit 1
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
  version = version;
  buildInputs = [
    script
  ];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${script}/bin/${name} $out/bin/${name}
  '';
}
