-- [[ AU Groups ]]

vim.cmd([[
  augroup salt_syn
    au BufNewFile,BufRead *.sls set filetype=sls.yaml.jinja
  augroup END
]])
