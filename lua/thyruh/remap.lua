vim.g.mapleader = " "  -- Set the leader key to space

-- Open file explorer with <leader>pv
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("Ex")
end)

-- pre setup with the types
vim.keymap.set("n", "<C-f>", "i#include <stdio.h>\n#include <stdbool.h>\n#include <stdint.h>\n\ntypedef int8_t i8;\ntypedef int16_t i16;\ntypedef int32_t i32;\ntypedef int64_t i64;\ntypedef uint8_t u8;\ntypedef uint16_t u16;\ntypedef uint32_t u32;\ntypedef uint64_t u64;\n\ntypedef bool b32;\n\ntypedef float f32;\ntypedef double f64;\n\nint main(void) {\nprintf(\"Hello, World!\\n\");\nreturn 0;\n}")

vim.keymap.set("n", "<C-u>", "<C-d>zz")
vim.keymap.set("n", "<C-i>", "<C-u>zz")

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])  -- Yanks the whole line to system clipboard in normal mode

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "E", "$")
vim.keymap.set("n", "Q", "0")
vim.keymap.set("n", "yE", "y$")
vim.keymap.set("n", "dE", "d$")

vim.g.mapleader = " "  -- Set the leader key to space

-- Open file explorer with <leader>pv
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("Ex")
end)

vim.keymap.set("n", "<C-u>", "<C-d>zz")
vim.keymap.set("n", "<C-i>", "<C-u>zz")

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])  -- Yanks selected text to system clipboard in normal and visual mode
vim.keymap.set("n", "<leader>Y", [["+Y]])  -- Yanks the whole line to system clipboard in normal mode

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- === Emacs-inspired window management ===

vim.keymap.set("n", "<leader>0", function()
    local cur_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= cur_win then
            vim.api.nvim_win_close(win, true)
        end
    end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>9", function()
    vim.cmd("vsplit")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>8", function()
    vim.cmd("split")
end, { noremap = true, silent = true })
