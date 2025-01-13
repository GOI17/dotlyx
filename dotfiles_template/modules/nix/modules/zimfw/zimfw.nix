{ lib, stdenv, fetchgit, customZimrc ? "" }:

with lib;

stdenv.mkDerivation rec {
  version = "1.16.0";
  name = "zimfw";
  src = fetchgit {
    url = "https://github.com/zimfw/zimfw.git";
    rev = "v${version}";
    sha256 = "uE+KJ8MBalT8YDjLr8F0OSEsVHHa5rntXQCw5/Kan0M=";
  };

  pathsToLink = [ "/share/zimfw" ];

  phases = "installPhase";

  installPhase = with builtins; ''
	outdir=$out/share/zimfw

	mkdir -p $outdir/.zim
	cp -r $src/* $outdir/.zim/
	cd $outdir
	echo "Zim files:
		$(ls -al .zim)
	"
	rm ./.zim/README.md ./.zim/LICENSE

	chmod -R +w .zim

	find ./.zim -type f -exec sed -i -e "s#\''${ZDOTDIR:-\''${HOME}}#$outdir#g" {} \;

	# Change the path to zim dir
	for template_file in $outdir/.zim/templates/*; do
		user_file="$outdir/.''$(basename -- $template_file)"
		cp $template_file $user_file
	done

	${optionalString (customZimrc != "")
	''echo '${customZimrc}' > $outdir/.zimrc ''
	}
  '';
}
