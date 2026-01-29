local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local telescope_builtin = require("telescope.builtin")

-- === Capabilities ===
local capabilities = cmp_nvim_lsp.default_capabilities(
   vim.lsp.protocol.make_client_capabilities()
)

-- === Utilities ===

-- Position encoding wrapper
do
    local orig = vim.lsp.util.make_position_params
    vim.lsp.util.make_position_params = function(win, encoding)
        if encoding == nil then
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            if #clients > 0 then
                encoding = clients[1].offset_encoding or "utf-16"
            else
                encoding = "utf-16"
            end
        end
        return orig(win, encoding)
    end
end

-- Strip CR from diagnostics to avoid ^M
do
    local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics then
            for _, d in ipairs(result.diagnostics) do
                if type(d.message) == "string" then
                    d.message = d.message:gsub("\r", "")
                end
            end
        end
        return orig(err, result, ctx, config)
    end
end

-- === Global LSP keymaps ===
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions or vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>f", function()
    vim.diagnostic.setloclist({ open = true })
end, opts)

-- === Mason setup ===
mason.setup({})
mason_lspconfig.setup({
    ensure_installed = { "clangd" },
    automatic_installation = true,
})

-- === Helper to prevent multiple serve-d clients per root ===
local function serve_d_root_dir(fname)
    return lspconfig.util.root_pattern("dub.json", ".git")(fname)
end

-- === serve-d setup ===
lspconfig.serve_d.setup({
    capabilities = capabilities,
    filetypes = { "d" },
    cmd = { "/home/thyruh/serve-d" },
    root_dir = lspconfig.util.root_pattern("dub.json", ".git"),
    flags = { debounce_text_changes = 150 },
    single_file_support = false,
})

-- === clangd setup ===
lspconfig.clangd.setup({
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
})

