-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.relativenumber = false
-- ~/.config/nvim/lua/config/options.lua

-- Only apply these settings on Windows
if vim.loop.os_uname().sysname == "Windows_NT" then
  -- Choose "pwsh" for PowerShell Core (recommended) or "powershell" for Windows PowerShell
  local shell_exe = "pwsh"

  -- Check if the modern pwsh is available, otherwise fall back to older powershell
  if vim.fn.executable("pwsh") == 1 then
    shell_exe = "pwsh"
  else
    shell_exe = "powershell"
  end

  vim.opt.shell = shell_exe

  -- The complex flag is needed for proper command execution and UTF-8 handling
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; &"

  -- Ensure output redirection also uses UTF-8 and passes exit code
  vim.opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

  -- Fix for command quoting issues
  vim.opt.shellxquote = ""
end
