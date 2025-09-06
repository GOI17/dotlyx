{
  # Default to the current user if available, otherwise fall back to "root".
  user = builtins.getEnv "USER" or "root";

  # Default to the current home directory if available, otherwise fall back to "/root".
  home = builtins.getEnv "HOME" or "/root";

  # Default dotfiles directory path.  If the environment variable is not set,
  # use a sensible default under the user's home directory.
  dotfilesDirectory = builtins.getEnv "DOTLYX_HOME_PATH" or "${home}/.dotfiles";

  # Default dotlyx home path.  If the environment variable is not set,
  # use a sensible default under the user's home directory.
  dotlyxDirectory = builtins.getEnv "DOTLYX_HOME_PATH" or "${home}/.dotlyx";
}
