local status, icons = pcall(require, "nvim-web-devicons")
if (not status) then return end

icons.setup {
  override = {},
  color_icons = true,
  default = false,

  strict = true,
  override_by_extension = {
    ["txt"] = {
      icon = "",
      color = "#EEDB8B",
      name = "Text"
    },
    ["sh"] = {
      icon = "",
      color = "#4EF037",
      name = "Sh"
    }
  }

}
