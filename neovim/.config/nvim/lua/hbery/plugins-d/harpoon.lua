local harpoon = require("harpoon")
local kms = vim.keymap.set

harpoon:setup()

kms("n", "<leader>ha", function() harpoon:list():add() end,                         { desc = "[H]arpoon [A]dd File"              })
kms("n", "<leader>hq", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "[H]arpoon Toggle [Q]uick Menu"     })

kms("n", "<leader>hj", function() harpoon:list():select(1) end,                     { desc = "[H]arpoon 1st File [J]"            })
kms("n", "<leader>hk", function() harpoon:list():select(2) end,                     { desc = "[H]arpoon 2nd File [K]"            })
kms("n", "<leader>hl", function() harpoon:list():select(3) end,                     { desc = "[H]arpoon 3rd File [L]"            })
kms("n", "<leader>h;", function() harpoon:list():select(4) end,                     { desc = "[H]arpoon 4th File [;]"            })

kms("n", "<leader>hp", function() harpoon:list():prev() end,                        { desc = "[H]arpoon [P]rev"                  })
kms("n", "<leader>hn", function() harpoon:list():next() end,                        { desc = "[H]arpoon [N]ext"                  })

if ( false ) then
  local conf = require("telescope.config").values
  local function toggle_telescope(hfiles)
    local fpaths = {}
    for _, item in ipairs(hfiles.items) do
      table.insert(fpaths, item.value)
    end

    require("telescope.pickers").new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = fpaths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    }):find()
  end

  kms("n", "<leader>ht", function()
                           toggle_telescope(harpoon:list())
                         end,
      { desc = "[H]arpoon Open [T]elescope Window" })
end
