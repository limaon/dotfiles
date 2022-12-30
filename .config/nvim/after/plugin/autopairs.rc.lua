local status1, autopairs = pcall(require, "nvim-autopairs")
local status2, commented = pcall(require, "commented")
if (not status1) then return end
if (not status2) then return end

autopairs.setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})


commented.setup({
  comment_padding = "",
  keybindings = { n = "<leader>c", v = "<leader>/", nl = "<leader>//" },
  prefer_block_comment = true,
  set_keybindings = true,
  ex_mode_cmd = "Comment"
})
