-- Ensure cmp and mason-lspconfig are available
local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then return end

local ok_mason, mason = pcall(require, "mason")
if not ok_mason then return end

local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok_mason then return end

-- Setup Mason first
mason.setup()

-- Setup nvim-cmp for autocompletion
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = {
  ['<M-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<M-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<M-Space>'] = cmp.mapping.complete(),
}

cmp.setup({
  mapping = cmp_mappings,
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- LSP on_attach function
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

-- List of servers you want
local servers = {"clangd"}

-- Setup Mason to ensure servers are installed
mason_lspconfig.setup({ ensure_installed = servers })

-- Setup LSP servers using vim.lsp.config safely
for _, server in ipairs(servers) do
  local cfg = vim.lsp.config[server]
  if cfg and cfg.setup then
    cfg.setup({
      on_attach = on_attach,
      capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      ),
    })
  end
end
