-- LSP keybindings for an improved editing experience
local M = {}

M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Buffer local mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Jump to definition
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  -- Jump to declaration
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  
  -- Show implementations (only if server supports it)
  if client.server_capabilities.implementationProvider then
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  end
  
  -- Show references (only if server supports it)
  if client.server_capabilities.referencesProvider then
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end
  
  -- Jump to type definition (only if server supports it)
  if client.server_capabilities.typeDefinitionProvider then
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  end
  
  -- Symbol information
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  
  -- Signature help (only if server supports it)
  if client.server_capabilities.signatureHelpProvider then
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  end
  
  -- Workspace management
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  
  -- Code actions and refactoring (only if server supports it)
  if client.server_capabilities.codeActionProvider then
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end
  
  if client.server_capabilities.renameProvider then
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end
  
  -- Format code (only if server supports it)
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
  end
  
  -- Diagnostic navigation
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  
  -- Custom actions based on language server capabilities
  if client.server_capabilities.documentHighlightProvider then
    local highlight_group = vim.api.nvim_create_augroup('LSPDocumentHighlight', { clear = false })
    vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = bufnr })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = highlight_group,
      buffer = bufnr,
      callback = function() vim.lsp.buf.document_highlight() end
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = highlight_group,
      buffer = bufnr,
      callback = function() vim.lsp.buf.clear_references() end
    })
  end
end

return M 