local M = {}
local utils = require("core.utils")

require("ui.lsp")

M.on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.document_range_formatting = true

    -- formatting
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_command [[augroup Format]]
        vim.api.nvim_command [[autocmd! * <buffer>]]
        vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
        vim.api.nvim_command [[augroup END]]
    end

    local lsp_mappings = utils.load_config().mappings.lspconfig
    utils.load_mappings({ lsp_mappings }, { buffer = bufnr })

    if client.supports_method "textDocument/signatureHelp" then
        vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
            pattern = "*",
            group = vim.api.nvim_create_augroup("LspSignature", {}),
            callback = function()
                vim.lsp.buf.signature_help()
            end,
        })
    end
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

local lspconfig = require("lspconfig")

lspconfig.flow.setup {
    on_attach = M.on_attach,
    capabilities = capabilities
}

lspconfig.sumneko_lua.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
}

lspconfig.tsserver.setup {
    on_attach = M.on_attach,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
}

lspconfig.cssls.setup { on_attach = M.on_attach, }
lspconfig.emmet_ls.setup { on_attach = M.on_attach }

lspconfig.pylsp.setup {
    on_attach = M.on_attach,
}

-- requires a file containing user's lspconfigs
local addlsp_confs = utils.load_config().plugins.options.lspconfig.setup_lspconf

if #addlsp_confs ~= 0 then
    require(addlsp_confs).setup_lsp(M.on_attach, capabilities)
end

return M
