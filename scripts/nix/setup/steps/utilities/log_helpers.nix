with import ./colors.nix;

rec {
  _colorized = { message, color }: ''
    echo "${color}${message}"
  '';
  _s = message: ''
    echo "\${_colorized { color = "${GREEN}"; message = "DOTLYX:"; } } ${message}"
  '';
  _e = message: ''
    echo "\${_colorized { color = "${RED}"; message = "DOTLYX:"; } } ${message}"
  '';
  _w = message: ''
    echo "\${_colorized { color = "${YELLOW}"; message = "DOTLYX:"; } } ${message}"
  '';
}
