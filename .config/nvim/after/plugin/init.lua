vim.cmd(":TSInstall all");

-- Ensure devicons are loaded first
local devicons_loaded, _ = pcall(require, "nvim-web-devicons")
if not devicons_loaded then
  print("Warning: nvim-web-devicons not found. Icons might not display properly.")
end

