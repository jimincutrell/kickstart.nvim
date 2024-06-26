-- Autocompletion
return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'onsails/lspkind.nvim'
	},
	config = function()
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'

		luasnip.config.setup {}

		local lspkind = require 'lspkind'
		vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })

		local has_words_before = function()
			if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
		end

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end
			},
			completion = { completeopt = 'menu,menuone,noinsert' },
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-y>'] = cmp.mapping.confirm { select = true },
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() and has_words_before() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					elseif cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
			formatting = {
				format = lspkind.cmp_format {
					mode = 'symbol',
					maxwidth = 50,
					ellipsis_char = '...',
					symbol_map = {
						Copilot = ""
					}
				},
			},
			sources = {
				{ name = 'copilot' },
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
			},
		}
	end
}

