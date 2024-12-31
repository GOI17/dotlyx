{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "obs-studio-bin";

  # URL del binario oficial de OBS Studio
  src = pkgs.fetchurl {
    url = "https://cdn-fastly.obsproject.com/downloads/obs-studio-31.0.0-macos-apple.dmg";
  };

  installPhase = ''
    mkdir -p $out/Applications
    echo "Mounting the DMG..."
    hdiutil attach $src -mountpoint /Volumes/OBS
    cp -R "/Volumes/OBS Studio/OBS Studio.app" $out/Applications/
    hdiutil detach "/Volumes/OBS"
  '';
}
