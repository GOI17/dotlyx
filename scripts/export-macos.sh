#!/bin/bash

output_file="$DOTLYX_HOME_PATH/macos_configurations_$(date +%Y%m%d).txt"
echo "Collecting current macOS configurations..." > "$output_file"

echo "System information:" >> "$output_file"
system_profiler SPSoftwareDataType SPHardwareDataType >> "$output_file"

echo -e "\nPower settings:" >> "$output_file"
pmset -g custom >> "$output_file"

echo -e "\nNetwork settings:" >> "$output_file"
networksetup -listallnetworkservices >> "$output_file"
for service in $(networksetup -listallnetworkservices | tail -n +2); do
    echo -e "\nSettings for $service:" >> "$output_file"
    networksetup -getinfo "$service" >> "$output_file"
done

echo -e "\nSystem Preferences:" >> "$output_file"
defaults read >> "$output_file"

echo -e "\nDock settings:" >> "$output_file"
defaults read com.apple.dock >> "$output_file"

echo -e "\nFinder settings:" >> "$output_file"
defaults read com.apple.finder >> "$output_file"

echo -e "\nLanguage and region settings:" >> "$output_file"
defaults read NSGlobalDomain AppleLanguages >> "$output_file"
defaults read NSGlobalDomain AppleLocale >> "$output_file"

echo -e "\nDisplay settings:" >> "$output_file"
system_profiler SPDisplaysDataType >> "$output_file"

echo -e "\nKeyboard settings:" >> "$output_file"
defaults read NSGlobalDomain KeyRepeat >> "$output_file"
defaults read NSGlobalDomain InitialKeyRepeat >> "$output_file"

# INFO: Optional exports
# echo -e "\nSecurity and privacy settings:" >> "$output_file"
# sudo spctl --status >> "$output_file"
# sudo fdesetup status >> "$output_file"

# echo -e "\nUsers and groups:" >> "$output_file"
# dscl . list /Users >> "$output_file"

echo "Configurations collected in: $output_file"
