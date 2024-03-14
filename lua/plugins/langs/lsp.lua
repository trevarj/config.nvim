---@diagnostic disable: missing-fields
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      { "folke/neoconf.nvim", config = false },
      { "folke/neodev.nvim", opts = {} },
      { "j-hui/fidget.nvim", opts = {} },
    },
    opts = function()
      local icons = require("config.icons")
      return {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = icons.from_severity,
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.error,
              [vim.diagnostic.severity.WARN] = icons.warning,
              [vim.diagnostic.severity.INFO] = icons.info,
              [vim.diagnostic.severity.HINT] = icons.hint,
            },
          },
          float = { border = "rounded" },
        },
        inlay_hints = {
          enabled = true,
        },
        -- add any global capabilities here
        capabilities = {},
        -- options for vim.lsp.buf.format
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          },
          bashls = {},
          taplo = {},
          yamlls = {},
          gopls = {},
        },
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {},
      }
    end,
    config = function(_, opts)
      local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
      require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))

      -- set borders
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
      require("lspconfig.ui.windows").default_options.border = "rounded"

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          require("config.keymaps").lsp_attach(args.buf)
        end,
      })

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = vim.tbl_deep_extend("force", {
            capabilities = vim.deepcopy(capabilities),
          }, server_opts or {})

          if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
              return
            end
          elseif opts.setup["*"] then
            if opts.setup["*"](server, server_opts) then
              return
            end
          end
          require("lspconfig")[server].setup(server_opts)
        end
      end
    end,
  },
}
