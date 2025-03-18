{
	 sudo="sudo ";
	 ".."="cd ..";
	 "..."="cd ../..";
	 ll="eza -l";
	 la="eza -la";
	 "~"="cd ~";
	 dotfiles="cd $USER_DOTFILES_PATH";
	 gaa="git add -A";
	 gcm="git commit -m";
	 grb="git rebase";
	 grbi="git rebase -i -r";
	 gca="git add --all && git commit --amend --no-edit";
	 gco="git checkout";
	 gd="$DOTLY_PATH/bin/dot git pretty-diff";
	 gs="git status -sb";
	 gf="git fetch --all -p";
	 gps="git push";
	 gpsf="git push --force";
	 gpl="git pull --rebase --autostash";
	 gb="git branch";
	 gpsup="git push -u origin '$(gb --show-current)'";
	 gl="$DOTLY_PATH/bin/dot git pretty-log";
	 gswitch="git switch";
	 "c."="(code $PWD &>/dev/null &)";
	 v="NVIM_APPNAME=nvim-scratch nvim";  # default Neovim config
	 vz="NVIM_APPNAME=nvim-lazyvim nvim"; # LazyVim
	 pin="jump pin";
	 unpin="jump unpin";
	 pins="jump pins";
	 k="kill -9";
	 "o."="open .";
	 up="dot package update_all";
	 chmodr="chmod -Rv";
	 ppath="echo '$PATH' | tr ':' '\n' | nl";
   dotlyx="$USER_DOTFILES_PATH/result/bin/dotlyx-setup";
}
