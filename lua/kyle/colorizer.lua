-- Adds color highlighting to hex codes
return {
	'norcalli/nvim-colorizer.lua',
	config = function()
		require('colorizer').setup()
	end
}
