#!/usr/bin/env bash
set -e

# save current directory
CUR_DIR="$(pwd)"

# update pkg and install essentials
pkg update -y && pkg upgrade -y
pkg install -y ripgrep lua53 clang make unzip ninja termux-api curl rust rust-analyzer wget file

# install neovim (Termux repo)
pkg install -y neovim

# setup Lua LSP (lua-language-server) manually
LUA_LS_DIR="$HOME/lua-language-server"
if [ ! -d "$LUA_LS_DIR" ]; then
  git clone https://github.com/sumneko/lua-language-server "$LUA_LS_DIR"
  cd "$LUA_LS_DIR"
  git submodule update --init --recursive
  cd 3rd/luamake && ./compile/install.sh
  cd "$LUA_LS_DIR"
  ./3rd/luamake/luamake rebuild
fi

# configure PATH for lua-ls
echo 'export PATH="$HOME/lua-language-server/bin:$PATH"' >> ~/.profile

# install JetBrainsMono Nerd Font
cd "$CUR_DIR"
mkdir -p ~/.termux
cp JetBrainsMonoNerdFont-Medium.ttf ~/.termux/font.ttf

# configure git config
git clone https://github.com/YKPAIHELIb/git-alias
{
    echo "[user]"
    echo "	email = 11073387+YKPAIHELIb@users.noreply.github.com"
    echo "	name = YKPAIHELIb"
    echo "[credential]"
    echo "	helper = store"
    echo "[core]"
    echo "	editor = nvim"
    cat ./git-alias/aliases.txt
} > ~/.gitconfig
echo "alias gconf='(cd ~ && nvim .gitconfig)'" >> ~/.bashrc

# Clone my neovim config
git clone --branch termux --single-branch https://github.com/YKPAIHELIb/config_nvim ~/.config/nvim/

echo "Termux setup completed!"
