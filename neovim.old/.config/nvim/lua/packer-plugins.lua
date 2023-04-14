require('packer').startup(
    function(use)
        use({
            "ThePrimeagen/harpoon",
            keys = { "<leader>hp" },
            config = function()
                require("telescope").load_extension("harpoon")
            end,
        })

        use({
            "kosayoda/nvim-lightbulb",
            after = "nvim-lspconfig",
            config = function()
                vim.cmd(
                    [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
                )
            end,
        })
        use({
            "nvim-neorg/neorg",
            branch = "main",
            config = [[ require("configs.neorg") ]],

            requires = {
                "nvim-neorg/neorg-telescope",
                -- "terrortylor/neorg-telescope",
            },
        })
    end
    )
