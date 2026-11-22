#!/usr/bin/env bash
set -e

# directory of this repo, the source of the dotfiles and the font
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# update pkg and install essentials
pkg update -y && pkg upgrade -y
pkg install -y git neovim ripgrep fzf bat git-delta lazygit clang make unzip \
  termux-api curl wget file bash-completion \
  rust rust-analyzer lua-language-server

# install JetBrainsMono Nerd Font
mkdir -p ~/.termux
cp "$REPO_DIR/JetBrainsMonoNerdFont-Medium.ttf" ~/.termux/font.ttf
termux-reload-settings

# Clone my neovim config
if [ ! -d ~/.config/nvim ]; then
  git clone https://github.com/YKPAIHELIb/config_nvim ~/.config/nvim
fi

# git config: my settings followed by my aliases
GIT_ALIAS_DIR="$(mktemp -d)"
git clone --depth 1 https://github.com/YKPAIHELIb/git-alias "$GIT_ALIAS_DIR"
cat "$REPO_DIR/dotfiles/gitconfig" "$GIT_ALIAS_DIR/aliases.txt" > ~/.gitconfig
rm -rf "$GIT_ALIAS_DIR"

# scripts sourced by bashrc: posh-git-sh prompt and git completion
curl -fsSL https://raw.githubusercontent.com/lyze/posh-git-sh/master/git-prompt.sh -o ~/.git-prompt.sh
curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# shell dotfiles
cp "$REPO_DIR/dotfiles/bashrc" ~/.bashrc
cp "$REPO_DIR/dotfiles/inputrc" ~/.inputrc
mkdir -p ~/.config/ripgrep
cp "$REPO_DIR/dotfiles/ripgreprc" ~/.config/ripgrep/config

echo "Termux setup completed! Restart Termux to load the new shell settings."
