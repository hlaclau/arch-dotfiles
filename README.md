# Arch Dotfiles

everything i use to setup my arch linux machine

## Setup

```bash
# Clone repository
git clone --recursive git@github.com:hlaclau/arch-dotfiles.git ~/arch-dotfiles
cd ~/arch-dotfiles

# Install packages
cd pkg && ./install.sh

# Symlink configs (using stow)
stow -t ~ .
```
