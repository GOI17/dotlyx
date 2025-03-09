# dotlyx [WIP]

## A personal dotlyxfiles manager 🧑🏻‍💻
### Installation
```
bash <(curl -s https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/install)
```
### Curious? Try it first
```
docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -w /root -it --rm alpine sh -uec '
  apk add curl sudo bash zsh git g++ python3
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/installer)"
  zsh'
```
```
docker run -e TERM -e COLORTERM -w /root -it --rm ubuntu sh -uec '
  apt-get update
  apt-get install -y curl build-essential sudo
  su -c bash -c "$(curl -fsSL https://raw.githubusercontent.com/GOI17/dotlyx/HEAD/installer)"
  su -c zsh'
```
### Another one?
#### Yes, but with Nix underhood 😎
#### Nix is the best alternative if you really want everything versioned. 

Credits to [Dotly](https://github.com/CodelyTV/dotly)
