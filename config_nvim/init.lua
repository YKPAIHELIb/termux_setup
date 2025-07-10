-- bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", "--branch=stable", lazypath
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/kickstart.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
})

-- Treesitter config
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "c", "cpp", "rust", "python", "bash" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- LSP setup without Mason
local nvim_lsp = require("lspconfig")
local lsp_flags = { debounce_text_changes = 150 }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Lua LS config
nvim_lsp.lua_ls.setup({
  cmd = { "lua-language-server" },
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

-- cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
})

-- keymaps and basic settings from Kickstart
require("kickstart")

-- disable mason
-- skip mason-lspconfig and mason.nvim entirely
