return {
	"windwp/nvim-autopairs",
	config = function()
		require("nvim-autopairs").setup {
			enable_moveright = false
		}
	end
}
