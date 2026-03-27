return {
  "folke/snacks.nvim",
  keys = {
    -- Always open picker at project root
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
  },
  opts = {
    picker = {
      hidden = true,
      sources = {
        -- These define their own options, we must override their defaults.
        files = { hidden = true },
        buffers = { hidden = true },
        -- Explorer and the rest of the sources don't define their own opts
        -- so it will use the picker options defined above and we can choose
        -- to override them if desired.
        explorer = {
          ignored = true,
          layout = {
            min_width = 20,
          },
        },
      },
    },
  },
}
