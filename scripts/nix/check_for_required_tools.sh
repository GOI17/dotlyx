#!/usr/bin/env bash

command_exists() {
	type "$1" >/dev/null 2>&1
}

if ! command_exists curl; then
	echo "DOTLYX: curl not installed, trying to install"

	if command_exists apt; then
		echo "DOTLYX: Installing using apt"
    echo "DOTLYX: Installing curl"
		sudo apt -y install curl 2>&1
	elif command_exists dnf; then
		echo "DOTLYX: Installing using dnf"
    echo "DOTLYX: Installing curl"
		sudo dnf -y install curl 2>&1
	elif command_exists yum; then
		echo "DOTLYX: Installing using yum"
    echo "DOTLYX: Installing curl"
		yes | sudo yum install curl 2>&1 
	elif command_exists brew; then
		echo "DOTLYX: Installing using brew"
    echo "DOTLYX: Installing curl"
		yes | brew install curl 2>&1 
	elif command_exists pacman; then
		echo "DOTLYX: Installing using pacman"
    echo "DOTLYX: Installing curl"
		sudo pacman -S --noconfirm curl 2>&1 
	else
		echo "DOTLYX: Could not install curl, no package provider found"
		exit 1
	fi
fi

if ! command_exists git; then
	echo "DOTLYX: git not installed, trying to install"

	if command_exists apt; then
		echo "DOTLYX: Installing using apt"
    echo "DOTLYX: Installing git"
		sudo apt -y install git 2>&1
	elif command_exists dnf; then
		echo "DOTLYX: Installing using dnf"
    echo "DOTLYX: Installing git"
		sudo dnf -y install git 2>&1
	elif command_exists yum; then
		echo "DOTLYX: Installing using yum"
    echo "DOTLYX: Installing git";
		yes | sudo yum install git 2>&1 
	elif command_exists brew; then
		echo "DOTLYX: Installing using brew"
    echo "DOTLYX: Installing git"
		yes | brew install git 2>&1 
	elif command_exists pacman; then
		echo "DOTLYX: Installing using pacman"
    echo "DOTLYX: Installing git"
		sudo pacman -S --noconfirm git 2>&1 
	else
		echo "DOTLYX: Could not install git, no package provider found"
		exit 1
	fi
fi

if ! command_exists python3; then
	echo "DOTLYX: python not installed, trying to install"

	if command_exists apt; then
		echo "DOTLYX: Installing using apt"
    echo "DOTLYX: Installing python"
		sudo apt -y install python3 2>&1
	elif command_exists dnf; then
		echo "DOTLYX: Installing using dnf"
    echo "DOTLYX: Installing python"
		sudo dnf -y install python3 2>&1
	elif command_exists yum; then
		echo "DOTLYX: Installing using yum"
    echo "DOTLYX: Installing python";
		yes | sudo yum install python3 2>&1 
	elif command_exists brew; then
		echo "DOTLYX: Installing using brew"
    echo "DOTLYX: Installing python"
		yes | brew install python3 2>&1 
	elif command_exists pacman; then
		echo "DOTLYX: Installing using pacman"
    echo "DOTLYX: Installing python"
		sudo pacman -S --noconfirm python3 2>&1 
	else
		echo "DOTLYX: Could not install python, no package provider found"
		exit 1
	fi
fi

if ! command_exists nix; then
	echo "DOTLYX: nix is not installed, trying to install"
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	curl -sSf -L https://install.lix.systems/lix | sh -s -- install
fi
