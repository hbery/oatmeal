-- [[ Configure NERDTree ]]

vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeMinimalUI = 1
vim.g.NERDTreeWinSize = 35

vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>', {})
