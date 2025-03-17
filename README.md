# Dotlyx

## A personal dotlyxfiles manager 🧑🏻‍💻

### Installation
```
bash <(curl -s https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/install)
```
### Curious? Try it first
```
docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -w /root -it --rm alpine sh -uec '
  apk add curl sudo bash zsh git g++ python3
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/install)"
  zsh'
```
```
docker run -e TERM -e COLORTERM -w /root -it --rm ubuntu sh -uec '
  apt-get update
  apt-get install -y curl build-essential sudo
  su -c bash -c "$(curl -fsSL https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/install)"
  su -c zsh'
```

### Working and planned features
|features                                       |   ❌  |   🔨  |   ⚠️   |   ✅  |
|-----------------------------------------------|-------|-------|-------|-------|
|Onboarding                                     |       |       |   ⚠️   |       |
|Custom dotfiles location                       |       |       |       |   ✅  |
|Rebuild flake after setup                      |       |   🔨  |       |       |
|Dotlyx core scripts                            |       |   🔨  |       |       |
|Update dotlyx core                             |   ❌  |       |       |       |
|UI app manager                                 |   ❌  |       |       |       |
|Auto build flake/home-manager updates changes  |   ❌  |       |       |   ✅  |
|Release versioning                             |   ❌  |       |       |       |

### Another one?
#### Yes, but with Nix underhood 😎
#### Nix is the best alternative if you really want everything versioned. 

Powered by
-   [Nix](https://nixos.org)
-   [Nix-darwin](https://github.com/LnL7/nix-darwin)
-   [home-manager](https://github.com/nix-community/home-manager)

Credits to
-   [Dotly](https://github.com/CodelyTV/dotly)
-   [dotSloth](https://github.com/gtrabanco/dotSloth)
