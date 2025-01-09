with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "zimfw-latest";
  src = fetchurl {
  	url = "https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
  	mkdir $ZIM_HOME
	mv $out $ZIM_HOME
	zsh "$ZIM_HOME/zimfw.zsh" install
  '';
}
