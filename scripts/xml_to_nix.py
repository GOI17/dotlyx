#!/usr/bin/env python3

import os
import plistlib
import re

DOTLYX_HOME = f"{os.path.expanduser('~')}/Documents/personal/workspace/dotlyx"
XML_DIR = f"{DOTLYX_HOME}/macos_defaults_xml"
NIX_DIR = f"{DOTLYX_HOME}/macos_defaults_nix"
os.makedirs(NIX_DIR, exist_ok=True)

# List of sensitive patterns (case-insensitive)
SENSITIVE_PATTERNS = [
    r"password",
    r"secret",
    r"token",
    r"auth",
    r"apikey",
    r"privatekey",
    r"keychain",
    r"bearer"
]

def contains_sensitive_data(key_or_value):
    """
    Check if the given string matches any of our sensitive patterns.
    Case-insensitive.
    """
    text = str(key_or_value).lower()
    for pattern in SENSITIVE_PATTERNS:
        if re.search(pattern, text):
            return True
    return False

def to_nix_value(value):
    """
    Convert a Python object (bool, int, str, dict, list, etc.) into a Nix-friendly string.
    """
    if isinstance(value, bool):
        return "true" if value else "false"
    elif isinstance(value, (int, float)):
        return str(value)
    elif isinstance(value, str):
        # Escape quotes if needed
        escaped = value.replace("\"", "\\\"")
        return f"\"{escaped}\""
    elif isinstance(value, dict):
        items = []
        for k, v in value.items():
            # Recursively convert the nested values
            items.append(f"{k} = {to_nix_value(v)};")
        return "{ " + " ".join(items) + " }"
    elif isinstance(value, list):
        # Convert each item in the list
        converted_items = [to_nix_value(item) + ";" for item in value]
        return "[ " + " ".join(converted_items) + " ]"
    else:
        # Fallback for unrecognized types
        return f"\"{str(value)}\""

def traverse_and_check(data, domain):
    """
    Traverse the data (dict/list) recursively to detect potential sensitive info.
    Returns the same structure but allows for optional redaction or logging.
    """
    if isinstance(data, dict):
        new_dict = {}
        for key, value in data.items():
            # Check keys
            if contains_sensitive_data(key):
                print(f"DOTLYX: [ALERT] Potential sensitive key found in domain '{domain}': {key}")
            # Check values (if it's a string, number, or something else)
            if isinstance(value, (str, int, float, bool)):
                if contains_sensitive_data(value):
                    print(f"DOTLYX: [ALERT] Potential sensitive value in domain '{domain}', key '{key}': {value}")
            # Recurse into nested dicts/lists
            new_dict[key] = traverse_and_check(value, domain)
        return new_dict
    elif isinstance(data, list):
        return [traverse_and_check(item, domain) for item in data]
    else:
        # It's a simple type (str, int, bool, etc.)
        return data

def main():
    # Iterate over all .xml files in XML_DIR
    for fname in os.listdir(XML_DIR):
        if not fname.endswith(".xml"):
            continue
        
        domain = fname.replace(".xml", "")
        xml_path = os.path.join(XML_DIR, fname)
        nix_path = os.path.join(NIX_DIR, f"{domain}.nix")

        print(f"DOTLYX: Processing domain: {domain}")

        # Read the XML (plist)
        try:
            with open(xml_path, "rb") as f:
                plist_data = plistlib.load(f)  # dict, list, etc.
        except Exception as e:
            print(f"DOTLYX: [WARNING] Could not parse {xml_path}: {e}")
            continue

        # Traverse for sensitive data
        checked_data = traverse_and_check(plist_data, domain)

        # Build a Nix structure
        lines = []
        lines.append("{")
        lines.append(f"  \"{domain}\" = {{")

        for k, v in checked_data.items() if isinstance(checked_data, dict) else []:
            nix_val = to_nix_value(v)
            lines.append(f"    {k} = {nix_val};")

        lines.append("  };")
        lines.append("}")

        # Write the .nix file
        with open(nix_path, "w", encoding="utf-8") as f:
            f.write("\n".join(lines))

        print(f"DOTLYX: [SUCCESS] Created: {nix_path}\n")

if __name__ == "__main__":
    main()
