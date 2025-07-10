#!/usr/bin/env bash
set -e

# update pkg and install essentials
pkg update -y && pkg upgrade -y
pkg install -y ripgrep lua53 clang make unzip ninja

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
source ~/.profile

echo "✔️ Termux setup completed: git, rg, neovim, treesitter deps, lua_ls"
