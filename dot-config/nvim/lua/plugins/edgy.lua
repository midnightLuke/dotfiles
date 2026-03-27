return {
  "folke/edgy.nvim",
  opts = function(_, opts)
    opts.right = opts.right or {}

    -- Claude Code terminal needs significantly more width than other right-sidebar panels.
    -- Filter by buffer name so other snacks terminals (e.g. bottom panel) are unaffected.
    table.insert(opts.right, 1, {
      title = "Claude",
      ft = "snacks_terminal",
      size = { width = 80 },
      filter = function(buf)
        return vim.api.nvim_buf_get_name(buf):find("claude") ~= nil
      end,
    })

    -- Ensure symbols-outline (and any other right-sidebar panels) stay narrow.
    for _, view in ipairs(opts.right) do
      if view.ft == "Outline" then
        view.size = view.size or {}
        view.size.width = 35
      end
    end
  end,
}
