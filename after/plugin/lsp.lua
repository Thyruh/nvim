local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Global capabilities
local capabilities = cmp_nvim_lsp.default_capabilities(
   vim.lsp.protocol.make_client_capabilities()
)

-- Shared on_attach
local on_attach = function(client, bufnr)
   local opts = { noremap = true, silent = true, buffer = bufnr }
local function go_to_definition()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
        if err or not result then return end
        local loc

        if vim.tbl_islist(result) then
            loc = result[1]  -- take the first location if multiple
        else
            loc = result  -- single Location
        end

        if not loc then return end

        -- Normalize LocationLink to Location
        if loc.targetUri or loc.targetRange then
            loc = {
                uri = loc.targetUri,
                range = loc.targetSelectionRange or loc.targetRange,
            }
        end

        -- Convert URI → buffer
        local bufnr = vim.uri_to_bufnr(loc.uri)
        if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.fn.bufload(bufnr)
        end

        -- Jump to line/col
        vim.api.nvim_set_current_buf(bufnr)
        local line = loc.range.start.line
        local col  = loc.range.start.character
        vim.api.nvim_win_set_cursor(0, {line + 1, col})
        vim.cmd("normal! zz")
    end)
end

   -- keymaps
   vim.keymap.set('n', 'gd', go_to_definition, opts)
   vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
   vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
   vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
   vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

   vim.keymap.set('n', '<leader>f', function()
      vim.diagnostic.setloclist({ open = true })  -- sends all diagnostics to location list
   end, opts)

end

-- === Mason setup ===
mason.setup({
   -- optional: PATH handling, etc.
})

-- Mason-lspconfig ensures clangd is installed
mason_lspconfig.setup({
   ensure_installed = { "clangd" },
   automatic_installation = true,
})

-- === Serve-d ===
lspconfig.serve_d.setup({
   on_attach = on_attach,
   capabilities = capabilities,
   filetypes = { "d" },
   cmd = { "/home/thyruh/serve-d" },
   root_dir = lspconfig.util.root_pattern("dub.json", ".git"),
   flags = { debounce_text_changes = 150 },
})

-- === clangd via Mason ===
lspconfig.clangd.setup({
   on_attach = on_attach,
   capabilities = capabilities,
   flags = { debounce_text_changes = 150 },
})

