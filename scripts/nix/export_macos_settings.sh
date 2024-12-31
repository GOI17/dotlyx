#!/usr/bin/env bash

# List of patterns considered "sensitive"
SENSITIVE_PATTERNS=(
  "password"
  "secret"
  "token"
  "auth"
  "apiKey"
  "privateKey"
  "keychain"
  "Bearer"
)

# Directory to store the exported defaults
OUTPUT_DIR="$DOTLYX_HOME_PATH/macos_defaults_xml"
mkdir -p $OUTPUT_DIR

# Get all domains (separated by commas) and convert them into lines
domains=$(defaults domains | tr ',' '\n')

for domain in $domains; do
  # Skip empty domains
  if [[ -z "$domain" ]]; then
    continue
  fi

  plist_path="$HOME/Library/Preferences/$domain.plist"
  
  if [[ -f "$plist_path" ]]; then
    echo "DOTLYX: Converting $plist_path..."

    plutil -convert xml1 -o "$OUTPUT_DIR/$domain.xml" "$plist_path" 2>/dev/null || {
      echo "DOTLYX: [WARNING] Could not read domain: $domain"
    }
  else
    echo "DOTLYX: [INFO] $domain does not have a .plist in ~/Library/Preferences."
  fi
done

sh <("$DOTLYX_HOME_PATH/scripts/xml_to_nix.py")

NIX_SRC_DIR="$DOTLYX_HOME_PATH/macos_defaults_nix"
OUTPUT_FILE="macos_defaults.nix"

echo "DOTLYX: [INFO] Merging all .nix files from '$NIX_SRC_DIR' into '$OUTPUT_FILE'..."

echo "{" > "$OUTPUT_FILE"

for nix_file in "$NIX_SRC_DIR"/*.nix; do
  [[ -e "$nix_file" ]] || {
    echo "DOTLYX: [INFO] No .nix files found in '$NIX_SRC_DIR'"
    break
  }

  echo "DOTLYX: [INFO] Adding $(basename "$nix_file")..."

  sed '1d;$d' "$nix_file" >> "$OUTPUT_FILE"
done

echo "}" >> "$OUTPUT_FILE"

echo "DOTLYX: [SUCCESS] Created '$OUTPUT_FILE'."
