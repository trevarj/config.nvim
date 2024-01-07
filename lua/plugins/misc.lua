return {
  {
    "mrjones2014/smart-splits.nvim",
    cmd = { "SmartCursorMoveUp", "SmartCursorMoveDown", "SmartCursorMoveLeft", "SmartCursorMoveRight" }
  },
  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    opts = {
      mapping = { "ww" },
      timeout = vim.o.timeoutlen,
      keys = function()
        return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
      end,
    },
  },
  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
  },
}
