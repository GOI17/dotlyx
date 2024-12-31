require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>e", "<CMD>Oil<CR>" ,{ desc = "Show oil explorer" })
map("n", "<leader>E", "<CMD>Oil --float<CR>" ,{ desc = "Show floating oil explorer" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
