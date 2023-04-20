-- Get platform dependant build script
local function tabnine_build_path()
  if vim.loop.os_uname().sysname == "Windows_NT" then
    return "pwsh.exe -file .\\dl_binaries.ps1"
  else
    return "./dl_binaries.sh"
  end
end
return {
	'codota/tabnine-nvim', build = tabnine_build_path(),
	config = function()
		require('tabnine').setup({
			disable_auto_comment=true,
			accept_keymap="<C-;>",
			dismiss_keymap = "<C-]>",
			debounce_ms = 800,
			suggestion_color = {gui = "#808080", cterm = 244},
			exclude_filetypes = {"TelescopePrompt"}
		})
	end
}
