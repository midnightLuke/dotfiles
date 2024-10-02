-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("dap.ext.vscode").load_launchjs()
require("orgmode").setup_ts_grammar()
