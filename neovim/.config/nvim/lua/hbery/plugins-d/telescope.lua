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

local tbuiltin = require('telescope.builtin')
local kms = vim.keymap.set

kms('n', '<leader>?', tbuiltin.oldfiles, { desc = '[?] Find recently opened files' })
kms('n', '<leader><space>', tbuiltin.buffers, { desc = '[ ] Find existing buffers' })
kms('n', '<leader>/', function()

  tbuiltin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })

end, { desc = '[/] Fuzzily search in current buffer' })
kms('n', '<leader>sw', tbuiltin.grep_string, { desc = '[S]earch current [W]ord' })
kms('n', '<leader>sg', tbuiltin.live_grep, { desc = '[S]earch by [G]rep' })

kms('n', '<leader>sf', tbuiltin.find_files, { desc = '[S]earch [F]iles' })
kms('n', '<leader>sG', tbuiltin.git_files, { desc = '[S]earch [G]it Files' })
kms('n', '<leader>sh', tbuiltin.help_tags, { desc = '[S]earch [H]elp' })
kms('n', '<leader>sd', tbuiltin.diagnostics, { desc = '[S]earch [D]iagnostics' })
kms('n', '<leader>sS', tbuiltin.git_status, { desc = '[S]how Git [S]tatus' })

kms('n', '<leader>hm', require('telescope').extensions.harpoon.marks, { desc = '[H]arpoon [M]arks' })

kms("n", "<Leader>gl", require('telescope').extensions.git_worktree.git_worktrees, { desc = "[G]it-worktree [L]ist", silent = true })
kms("n", "<Leader>gC", require('telescope').extensions.git_worktree.create_git_worktree, { desc = "[G]it-worktree [C]reate worktree", silent = true })

-- kms("n", "<Leader>sn", require('telescope').extensions.notify.notify, { desc = "[S]how [N]otifications", silent = true })
