local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local kms = vim.keymap.set

kms("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [A]dd File" })
kms("n", "<leader>hq", ui.toggle_quick_menu, { desc = "[H]arpoon Toggle [Q]uick Menu" })

kms("n", "<leader>hj", function() ui.nav_file(1) end, { desc = "[H]arpoon 1st File" })
kms("n", "<leader>hk", function() ui.nav_file(2) end, { desc = "[H]arpoon 2nd File" })
kms("n", "<leader>hl", function() ui.nav_file(3) end, { desc = "[H]arpoon 3rd File" })
kms("n", "<leader>h;", function() ui.nav_file(4) end, { desc = "[H]arpoon 4th File" })
