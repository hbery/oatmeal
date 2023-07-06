-- [[ Configure Telescope ]]

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()

  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })

end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>pf', require('telescope.builtin').find_files, { desc = '[P]rompt-search [F]iles' })
vim.keymap.set('n', '<leader>ph', require('telescope.builtin').help_tags, { desc = '[P]rompt-search [H]elp' })
vim.keymap.set('n', '<leader>pw', require('telescope.builtin').grep_string, { desc = '[P]rompt-search current [W]ord' })
vim.keymap.set('n', '<leader>pg', require('telescope.builtin').live_grep, { desc = '[P]rompt-search by [G]rep' })
vim.keymap.set('n', '<leader>pd', require('telescope.builtin').diagnostics, { desc = '[P]rompt-search [D]iagnostics' })
