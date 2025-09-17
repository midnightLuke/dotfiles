return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "shellcheck",
        "shfmt",
        "php-debug-adapter",
        "intelephense",
      },
    },
  },
}
