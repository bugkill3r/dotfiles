-- NOTE: no `:TSInstall all` here — parsers come from `ensure_installed` in
-- after/plugin/treesitter.lua (go/java/cpp/rust/python). Installing "all"
-- pulled ~317 parsers on every startup.

-- Ensure devicons are loaded first
local devicons_loaded, _ = pcall(require, "nvim-web-devicons")
if not devicons_loaded then
  print("Warning: nvim-web-devicons not found. Icons might not display properly.")
end
