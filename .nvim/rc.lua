local linters = require('lint').linters

table.insert(linters.selene.args, 1, "--config")
table.insert(linters.selene.args, 2, ".nvim/selene.toml")

table.insert(linters.luacheck.args, 1, "--config")
table.insert(linters.luacheck.args, 2, ".nvim/luacheckrc")

vim.notify("Exrc loaded!")
