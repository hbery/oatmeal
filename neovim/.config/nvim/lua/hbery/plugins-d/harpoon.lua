local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local kms = vim.keymap.set

kms("n", "<leader>ha", mark.add_file)
kms("n", "<leader>hq", ui.toggle_quick_menu)

kms("n", "<leader>hj", function() ui.nav_file(1) end)
kms("n", "<leader>hk", function() ui.nav_file(2) end)
kms("n", "<leader>hl", function() ui.nav_file(3) end)
kms("n", "<leader>h;", function() ui.nav_file(4) end)
