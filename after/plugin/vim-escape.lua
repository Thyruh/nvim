-- Tap-hold Ctrl → Escape inside Neovim

local vim = vim
local timer = vim.loop.new_timer()
local ctrl_pressed = false
local timeout = 150 -- milliseconds for tap vs hold

-- Helper to send <Esc>
local function send_esc()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

-- Track press and release
vim.api.nvim_set_keymap('i', '<C>', '', {
  noremap = true,
  silent = true,
  callback = function()
    ctrl_pressed = true

    -- start timer
    timer:start(timeout, 0, vim.schedule_wrap(function()
      if ctrl_pressed then
        -- tap detected
        send_esc()
        ctrl_pressed = false
      end
    end))
  end
})

-- Detect Ctrl + another key (normal hold)
vim.api.nvim_set_keymap('i', '<C-Any>', '', {
  noremap = true,
  silent = true,
  callback = function()
    ctrl_pressed = false
  end
})

