local status_ok, _ = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all"
  ensure_installed = "all",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

local status_ok2, _ = pcall(require, "spellsitter")
if not status_ok2 then
  return
end

require("spellsitter").setup()
