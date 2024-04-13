local sr_sb = require("search-replace.single-buffer")
local sr_mb = require("search-replace.multi-buffer")
local sr_ui = require("search-replace.ui")
local sr_vs = require("search-replace.visual-multitype")
local kms = vim.keymap.set

kms('v', "<leader>rr", sr_sb.visual_charwise_selection, { desc = "Search[R]eplace Selection [R]eplace"            })
kms('v', "<leader>rs", sr_vs.within,                    { desc = "Search[R]eplace [S]election Within"             })
kms('v', "<leader>rb", sr_vs.within_cword,              { desc = "Search[R]eplace Within [Block] Selection"       })

kms('n', "<leader>rs", sr_ui.single_buffer_selections,  { desc = "List Search[R]eplace SingleBuffer [S]elections" })
kms('n', "<leader>ro", sr_sb.open,                      { desc = "Search[R]eplace [O]pen"                         })
kms('n', "<leader>rw", sr_sb.cword,                     { desc = "Search[R]eplace [W]ord"                         })
kms('n', "<leader>rW", sr_sb.cWORD,                     { desc = "Search[R]eplace [W]ORD"                         })
kms('n', "<leader>re", sr_sb.cexpr,                     { desc = "Search[R]eplace [E]xpr"                         })
kms('n', "<leader>rf", sr_sb.cfile,                     { desc = "Search[R]eplace [F]ile"                         })

kms('n', "<leader>rbs", sr_ui.multi_buffer_selections,  { desc = "List Search[R]eplace MultiBuffer [S]elections" })
kms('n', "<leader>rbo", sr_mb.open,                     { desc = "Search[R]eplace [B]lock [O]pen"                })
kms('n', "<leader>rbw", sr_mb.cword,                    { desc = "Search[R]eplace [B]lock [W]ord"                })
kms('n', "<leader>rbW", sr_mb.cWORD,                    { desc = "Search[R]eplace [B]lock [W]ORD"                })
kms('n', "<leader>rbe", sr_mb.cexpr,                    { desc = "Search[R]eplace [B]lock [E]xpr"                })
kms('n', "<leader>rbf", sr_mb.cfile,                    { desc = "Search[R]eplace [B]lock [F]ile"                })

-- show the effects of a search / replace in a live preview window
vim.o.inccommand = "split"
