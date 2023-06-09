require("hbery.telescope")
require("hbery.lsp")
require("hbery.treesitter")
-- require("hbery.startup")
require("hbery.neorg")

P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end
