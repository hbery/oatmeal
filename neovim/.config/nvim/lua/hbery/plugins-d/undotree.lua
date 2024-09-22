-- [[ Configure Undotree ]]

local kms = vim.keymap.set
local g   = vim.g
local undodir = vim.fn.stdpath 'state' .. '/undo'
local dir_present = false

if not vim.loop.fs_stat(undodir) then
  vim.loop.fs_mkdir(undodir, 700, function (err, success)
    if not success then
      vim.print("Cannot create dir: " .. undodir .. " due to error (" .. err .. ")")
    end
  end)
else
  dir_present = true
end

g.undotree_WindowLayout = 4
g.undotree_HelpLine     = 1
if dir_present then
  g.undotree_UndoDir    = undodir
end

kms('n', '<leader>u', vim.cmd.UndotreeToggle, { silent = true, desc = "Toggle [U]ndotree" })


