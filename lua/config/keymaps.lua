local M = {}

function M.lsp_attach(buffer)
  local lsp = vim.lsp.buf
  local t = require("telescope.builtin")
  local function map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = buffer, desc = "LSP: " .. desc })
  end

  map("n", "<leader>ca", lsp.code_action, "Code Action")
  map("n", "<leader>cf", lsp.format, "Code Format")
  map("n", "<leader>cr", lsp.rename, "Rename")
  map("n", "<leader>cs", t.lsp_document_symbols, "Document Symbols")
  map("n", "gd", t.lsp_definitions, "Goto Definition")
  map("n", "gr", t.lsp_references, "Goto References")
  map("n", "gD", lsp.declaration, "Goto Declaration")
  map("n", "gI", t.lsp_implementations, "Goto Implementations")
  map("n", "gy", t.lsp_type_definitions, "Goto Type Definition")
  map("n", "K", lsp.hover, "Hover Documentation")
  map("n", "gK", lsp.signature_help, "Signature Help")
  map("i", "<C-k>", lsp.signature_help, "Signature Help")
end

function M.git_attach(gs, buffer)
  local function map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
  end

  -- Navigation
  map("n", "]h", gs.next_hunk, "Next Hunk")
  map("n", "[h", gs.prev_hunk, "Prev Hunk")
  -- Actions
  map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
  map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
  map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
  map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
  map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk")
  map("n", "<leader>ghb", function()
    gs.blame_line({ full = true })
  end, "Blame Line")
  map("n", "<leader>ghd", gs.diffthis, "Diff This")
  map("n", "<leader>ghD", function()
    gs.diffthis("~")
  end, "Diff This ~")
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end

function M.init()
  local wk = require("which-key")
  wk.register({
    ["<leader>"] = {
      b = {
        name = "Buffer",
        a = { "<cmd>e #<cr>", "Previous Buffer" },
        c = { "<cmd>%bd|e#|bd#<cr><cr>", "Close All Others" },
        d = { "<cmd>bdel<cr>", "Close" },
        A = { "<cmd>%bdel<cr>", "Close All" },
        D = { "<cmd>bdel!<cr>", "Force Close" },
      },
      c = {
        name = "Code",
        l = { "<cmd>LspInfo<cr>", "LSP Info" },
      },
      C = {
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        "Config Files",
      },
      e = { "<cmd>Neotree toggle reveal<cr>", "File Explorer" },
      f = {
        name = "File",
        b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
        h = {
          function()
            require("telescope.builtin").find_files({
              no_ignore = true,
              hidden = true,
            })
          end,
          "Find Files (no ignore)",
        },
        j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
        l = { "<cmd>Telescope resume<cr>", "Last Search" },
        n = { "<cmd>enew<cr>", "New File" },
        w = { "<cmd>Telescope grep_string<cr>", "Find Word" },
        f = { "<cmd>Telescope find_files<cr>", "Find Files" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent Files" },
      },
      g = { name = "Git", h = { "Hunks" } },
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
      [" "] = { "<cmd>Telescope find_files<cr>", "Find Files" },
      ["/"] = { "<cmd>Telescope live_grep<cr>", "Grep (cwd)" },
      ["|"] = { "<cmd>vsplit<cr>", "Vertical Split" },
      ["-"] = { "<cmd>split<cr>", "Horizontal Split" },
      ["`"] = { "<cmd>e #<cr>", "Previous Buffer" },
    },
    ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    ["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({ severity = 'ERROR' })<cr>", "Prev Diagnostic" },
    ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    ["]e"] = { "<cmd>lua vim.diagnostic.goto_next({ severity = 'ERROR' })<cr>", "Next Diagnostic" },
    -- Move to tmux window using the <ctrl> hjkl keys
    ["<C-h>"] = { mode = { "n", "i", "x" }, "<cmd>SmartCursorMoveLeft<cr>", "Go to left window" },
    ["<C-j>"] = { mode = { "n", "i", "x" }, "<cmd>SmartCursorMoveDown<cr>", "Go to lower window" },
    ["<C-k>"] = { mode = { "n", "i", "x" }, "<cmd>SmartCursorMoveUp<cr>", "Go to upper window" },
    ["<C-l>"] = { mode = { "n", "i", "x" }, "<cmd>SmartCursorMoveRight<cr>", "Go to right window" },
    -- Quick save
    ["<C-s>"] = { mode = { "n", "i", "x", "s" }, "<cmd>w<cr><esc>", "Save file" },
    -- Indent lines
    [">"] = { mode = { "v" }, ">gv", "Indent" },
    ["<"] = { mode = { "v" }, "<gv", "De-dent" },
    ["<esc>"] = { mode = { "n", "i" }, "<cmd>noh<cr><esc>", "Clear Search Highlighting" },
    ["<esc><esc>"] = { mode = { "t" }, "<C-\\><C-n>", "Escape terminal mode" },
  })

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
