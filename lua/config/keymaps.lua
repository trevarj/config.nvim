local M = {}

local function map(mode, l, r, desc, buffer)
  vim.keymap.set(mode, l, r, { buffer = buffer or true, desc = desc })
end

function M.lsp_attach(buffer)
  local lsp = vim.lsp.buf
  local t = function(func)
    return string.format("<cmd>Telescope %s<cr>", func)
  end
  local pfx = "LSP: "
  local function bmap(mode, l, r, desc)
    map(mode, l, r, desc, buffer)
  end

  bmap("n", "<leader>ca", lsp.code_action, pfx .. "Code Action")
  bmap("n", "<leader>cd", t("diagnostics"), pfx .. "Diagnostics")
  bmap("n", "<leader>cr", lsp.rename, pfx .. "Rename")
  bmap("n", "<leader>cs", t("lsp_document_symbols"), pfx .. "Document Symbols")
  bmap("n", "gd", t("lsp_definitions"), pfx .. "Goto Definition")
  bmap("n", "gr", t("lsp_references"), pfx .. "Goto References")
  bmap("n", "gD", lsp.declaration, pfx .. "Goto Declaration")
  bmap("n", "gI", t("lsp_implementations"), pfx .. "Goto Implementations")
  bmap("n", "gy", t("lsp_type_definitions"), pfx .. "Goto Type Definition")
  bmap("n", "K", lsp.hover, pfx .. "Hover Documentation")
  bmap("n", "gK", lsp.signature_help, pfx .. "Signature Help")
  bmap("i", "<C-k>", lsp.signature_help, pfx .. "Signature Help")
end

function M.git_attach(gs, buffer)
  local function bmap(mode, l, r, desc)
    map(mode, l, r, desc, buffer)
  end

  -- Navigation
  bmap("n", "]h", gs.next_hunk, "Next Hunk")
  bmap("n", "[h", gs.prev_hunk, "Prev Hunk")
  -- Actions
  bmap({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
  bmap({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  bmap("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
  bmap("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
  bmap("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
  bmap("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk")
  bmap("n", "<leader>ghb", function()
    gs.blame_line({ full = true })
  end, "Blame Line")
  bmap("n", "<leader>ghd", gs.diffthis, "Diff This")
  bmap("n", "<leader>ghD", function()
    gs.diffthis("~")
  end, "Diff This ~")
  bmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end

function M.nvim_surround()
  local pfx = "Surround: "
  local m = {
    { "i", "<C-g>s", "<Plug>(nvim-surround-insert)", pfx .. "Cursor" },
    { "i", "<C-g>S", "<Plug>(nvim-surround-insert-line)", pfx .. "Cursor newline" },
    { "n", "gs", "<Plug>(nvim-surround-normal)", pfx .. "Motion" },
    { "n", "gss", "<Plug>(nvim-surround-normal-cur)", pfx .. "Current line" },
    { "n", "gsS", "<Plug>(nvim-surround-normal-line)", pfx .. "Current line on newlines" },
    { "n", "gsN", "<Plug>(nvim-surround-normal-cur-line)", pfx .. "On newlines" },
    { "x", "S", "<Plug>(nvim-surround-visual)", pfx .. "Visual selection" },
    { "x", "gS", "<Plug>(nvim-surround-visual-line)", pfx .. "Visual selection on newlines" },
    { "n", "ds", "<Plug>(nvim-surround-delete)", pfx .. "Delete" },
    { "n", "cs", "<Plug>(nvim-surround-change)", pfx .. "Change pairs" },
    { "n", "cS", "<Plug>(nvim-surround-change-line)", pfx .. "Change pairs on newlines" },
  }
  local keys = {}
  for _, v in ipairs(m) do
    table.insert(keys, { v[2], v[3], mode = v[1], desc = v[4] })
  end
  return keys
end

function M.comment()
  return {
    { "gc", mode = "n", desc = "Comment" },
    { "gcc", mode = "n", desc = "Comment line" },
    { "gc", mode = "x", desc = "Comment selection" },
    { "gc", mode = "o", desc = "Comment textobject" },
  }
end

function M.spectre()
  return {
    {
      "<leader>sr",
      function()
        require("spectre").toggle()
      end,
      mode = "n",
      desc = "Search and Replace",
    },
  }
end

function M.init()
  local wk = require("which-key")
  local t = function()
    return require("telescope.builtin")
  end
  wk.register({
    ["<leader>"] = {
      b = {
        name = "Buffer",
        a = { "<cmd>e #<cr>", "Previous Buffer" },
        c = { "<cmd>%bd|e#|bd#<cr><cr>", "Close All Others" },
        d = { "<cmd>bp|bdel #<cr>", "Close" },
        A = { "<cmd>%bdel<cr>", "Close All" },
        D = { "<cmd>bdel!<cr>", "Force Close" },
      },
      c = {
        name = "Code",
        l = { "<cmd>LspInfo<cr>", "LSP Info" },
        f = {
          function()
            require("conform").format()
          end,
          "Format",
        },
      },
      C = {
        function()
          t().find_files({ cwd = vim.fn.stdpath("config") })
        end,
        "Config Files",
      },
      e = { "<cmd>Neotree toggle reveal<cr>", "File Explorer" },
      f = {
        name = "File",
        b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
        h = {
          function()
            t().find_files({
              no_ignore = true,
              hidden = true,
            })
          end,
          "Find Files (no ignore)",
        },
        H = {
          function()
            t().find_files({
              cwd = "~",
              hidden = true,
            })
          end,
          "Find Files (home)",
        },
        j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
        l = { "<cmd>Telescope resume<cr>", "Last Search" },
        n = { "<cmd>enew<cr>", "New File" },
        w = { "<cmd>Telescope grep_string<cr>", "Find Word" },
        f = { "<cmd>Telescope find_files<cr>", "Find Files" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent Files" },
      },
      g = {
        name = "Git",
        b = { "<cmd>Telescope git_branches<cr>", "Branches" },
        c = { "<cmd>Telescope git_commits<cr>", "Commits" },
        h = { "Hunks" },
        s = { "<cmd>Telescope git_status<cr>", "Status" },
      },
      l = { "<cmd>Lazy<cr>", "Lazy" },
      s = {
        name = "Search",
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        g = { "<cmd>Telescope live_grep<cr>", "Grep (cwd)" },
        h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
      },
      u = {
        name = "UI",
        t = { "<cmd>TSContextToggle<cr>", "Toggle Treesitter Context" },
        f = { "<cmd>ToggleFormat<cr>", "Toggle Format On Save" },
      },
      q = {
        name = "Quit",
        l = {
          function()
            require("persistence").load({ last = true })
          end,
          "Restore Last Session",
        },
        r = {
          function()
            require("persistence").load()
          end,
          "Restore Session",
        },
        s = {
          function()
            require("persistence").stop()
          end,
          "Session Stop",
        },
        q = { "<cmd>qa<cr>", "Quit all" },
      },
      [" "] = {
        function()
          -- try git_files and fallback to find_files if not git dir
          xpcall(function()
            t().git_files({
              no_ignore = true,
              hidden = true,
              show_untracked = true,
            })
          end, function(_)
            t().find_files()
          end)
        end,
        "Find Files",
      },
      ["/"] = { "<cmd>Telescope live_grep<cr>", "Grep (cwd)" },
      ["|"] = { "<cmd>vsplit<cr>", "Vertical Split" },
      ["-"] = { "<cmd>split<cr>", "Horizontal Split" },
      ["`"] = { "<cmd>e #<cr>", "Previous Buffer" },
    },
    ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    ["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({ severity = 'ERROR' })<cr>", "Prev Diagnostic" },
    ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    ["]e"] = { "<cmd>lua vim.diagnostic.goto_next({ severity = 'ERROR' })<cr>", "Next Diagnostic" },
    -- Center on half page jump
    ["<C-d>"] = { "<C-d>zz", "Half page down" },
    ["<C-u>"] = { "<C-u>zz", "Half page up" },
    -- Move to tmux window using the <ctrl> hjkl keys
    ["<C-h>"] = { mode = { "n", "i", "x", "t" }, "<cmd>SmartCursorMoveLeft<cr>", "Go to left window" },
    ["<C-j>"] = { mode = { "n", "i", "x", "t" }, "<cmd>SmartCursorMoveDown<cr>", "Go to lower window" },
    ["<C-k>"] = { mode = { "n", "i", "x", "t" }, "<cmd>SmartCursorMoveUp<cr>", "Go to upper window" },
    ["<C-l>"] = { mode = { "n", "i", "x", "t" }, "<cmd>SmartCursorMoveRight<cr>", "Go to right window" },
    -- Buffers
    H = { "<cmd>bprev<cr>", "Previous Buffer" },
    L = { "<cmd>bnext<cr>", "Next Buffer" },
    -- Quick save
    ["<C-s>"] = { mode = { "n", "i", "x", "s" }, "<cmd>w<cr><esc>", "Save file" },
    -- Indent lines
    [">"] = { mode = { "v" }, ">gv", "Indent" },
    ["<"] = { mode = { "v" }, "<gv", "De-dent" },
    ["<esc>"] = { mode = { "n", "i" }, "<cmd>noh<cr><esc>", "Clear Search Highlighting" },
    ["<esc><esc>"] = { mode = { "t" }, "<C-\\><C-n>", "Escape terminal mode" },
  })

  -- Better Up/Down, keeps selection when moving lines in visual mode
  wk.register({
    j = { "v:count == 0 ? 'gj' : 'j'", "Down" },
    k = { "v:count == 0 ? 'gk' : 'k'", "Up" },
  }, { mode = { "n", "x" }, expr = true, silent = true })

  -- Moving lines
  wk.register({
    ["<A-j>"] = { "<cmd>m .+1<cr>==", "Move Line down" },
    ["<A-k>"] = { "<cmd>m .-2<cr>==", "Move Line up" },
  }, { mode = "n" })
  wk.register({
    ["<A-j>"] = { "<esc><cmd>m .+1<cr>==gi", "Move Line down" },
    ["<A-k>"] = { "<esc><cmd>m .-2<cr>==gi", "Move Line up" },
  }, { mode = "i" })
  wk.register({
    ["<A-j>"] = { ":m '>+1<cr>gv=gv", "Move Lines Down" },
    ["<A-k>"] = { ":m '<-2<cr>gv=gv", "Move Lines Up" },
  }, { mode = "v" })

  -- Jump to buffers using Alt-[1-0]
  for bufn = 1, 10, 1 do
    local cmd = string.format("<cmd>LualineBuffersJump! %s<cr>", bufn)
    local key = string.format("<A-%s>", bufn % 10)
    local desc = string.format("Buffer %s", bufn)
    wk.register({ [key] = { cmd, desc } })
  end
end

return M
