-- [[ Configure Keymaps ]]
local kms = vim.keymap.set

-- Keymaps for better default experience
kms({ 'n', 'v' }, '<Space>', '<Nop>',            {              silent = true                 })

-- Remap for dealing with word wrap
kms('n', 'k', "v:count == 0 ? 'gk' : 'k'",       { expr = true, silent = true                 })
kms('n', 'j', "v:count == 0 ? 'gj' : 'j'",       { expr = true, silent = true                 })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
kms('n', '[d',        vim.diagnostic.goto_prev,  { desc = "Go to previous diagnostic message" })
kms('n', ']d',        vim.diagnostic.goto_next,  { desc = "Go to next diagnostic message"     })
kms('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message"  })
kms('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list"             })
