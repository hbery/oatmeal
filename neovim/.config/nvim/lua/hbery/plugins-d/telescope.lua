-- [[ Configure Telescope ]]
require('telescope').load_extension('harpoon')
require('telescope').load_extension('git_worktree')

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
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

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sS', require('telescope.builtin').git_status, { desc = '[S]how Git [S]tatus' })

vim.keymap.set('n', '<leader>hm', require('telescope').extensions.harpoon.marks, { desc = '[H]arpoon [M]arks' })

vim.keymap.set("n", "<Leader>gl", require('telescope').extensions.git_worktree.git_worktrees, { desc = "[G]it-worktree [L]ist", silent = true })
vim.keymap.set("n", "<Leader>gC", require('telescope').extensions.git_worktree.create_git_worktree, { desc = "[G]it-worktree [C]reate worktree", silent = true })

-- vim.keymap.set("n", "<Leader>sn", require('telescope').extensions.notify.notify, { desc = "[S]how [N]otifications", silent = true })
