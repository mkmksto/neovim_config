return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local cmp_types_config = require("cmp.types")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		-- https://www.reddit.com/r/neovim/comments/woih9n/how_to_set_lsp_autocomplete_priority/
		-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua
		local function deprioritize_snippet(entry1, entry2)
			if entry1:get_kind() == cmp_types_config.lsp.CompletionItemKind.Snippet then
				return false
			end
			if entry2:get_kind() == cmp_types_config.lsp.CompletionItemKind.Snippet then
				return true
			end
		end

		local function deprioritize_bufftext(entry1, entry2)
			if entry1:get_kind() == cmp_types_config.lsp.CompletionItemKind.Text then
				return false
			end
			if entry2:get_kind() == cmp_types_config.lsp.CompletionItemKind.Text then
				return true
			end
		end

		local function formatForTailwindCSS(entry, vim_item)
			if vim_item.kind == "Color" and entry.completion_item.documentation then
				local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
				if r then
					local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
					local group = "Tw_" .. color
					if vim.fn.hlID(group) < 1 then
						vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
					end
					vim_item.kind = "●"
					vim_item.kind_hl_group = group
					return vim_item
				end
			end
			vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
			return vim_item
		end

		cmp.setup({
			-- https://github.com/hrsh7th/nvim-cmp/issues/209
			completion = {
				completeopt = "menu,menuone,preview,noinsert",
			},
			-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques
			enabled = function()
				-- disable completion in comments
				local context = require("cmp.config.context")
				-- keep command mode completion enabled when cursor is in a comment
				if vim.api.nvim_get_mode().mode == "c" then
					return true
				else
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end
			end,

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<S-Tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<Tab>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-k>"] = cmp.mapping.scroll_docs(-4), -- Ctrl + j/k to scroll through cmp docs
				["<C-j>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				-- { name = "nvim_lsp", max_item_count = 11, priority = 10, keyword_length = 2 }, -- lsp as source for autocompletion
				{ name = "nvim_lsp", max_item_count = 11, priority = 10 }, -- lsp as source for autocompletion
				{ name = "nvim_lsp_signature_help", priority = 9 }, -- displays args for current function
				{ name = "path", max_item_count = 5, priority = 7, keyword_length = 2 }, -- file system paths
				{ name = "luasnip", max_item_count = 4, priority = 5, keyword_length = 3 }, -- snippets
				{ name = "buffer", max_item_count = 5, priority = 4, keyword_length = 4 }, -- text within current buffer
				-- { name = "dictionary", max_item_count = 8, priority = 4, keyword_length = 2 }, -- english dictionary
			}),
			-- https://github.com/hrsh7th/nvim-cmp/issues/183
			-- https://www.reddit.com/r/neovim/comments/u3c3kw/how_do_you_sorting_cmp_completions_items/
			-- (Lower Emmet Snippets) https://www.reddit.com/r/neovim/comments/woih9n/how_to_set_lsp_autocomplete_priority/
			sorting = {
				priority_weight = 2.0,
				-- https://www.youtube.com/watch?v=p7TIag1GRDE&list=PLOe6AggsTaVuIXZU4gxWJpIQNHMrDknfN&index=23
				comparators = {
					deprioritize_snippet,
					cmp.config.compare.exact,
					deprioritize_bufftext,
					-- require("cmp-under-comparator").under,
					cmp.config.compare.recently_used,
					cmp.config.compare.length, -- prefer shorter over longer matches
					cmp.config.compare.locality,
					-- function(entry1, entry2)
					--     local kind1 = kind_score[kind_mapper[entry1:get_kind()]] or 50
					--     local kind2 = kind_score[kind_mapper[entry2:get_kind()]] or 50
					--     if kind1 < kind2 then
					--         return true
					--     end
					-- end,
					cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
					cmp.config.compare.offset,
					cmp.config.compare.scopes,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.order,
				},
			},
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 35,
					ellipsis_char = "...",
					menu = {
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						path = "[Path]",
					},
					before = function(entry, vim_item)
						vim_item = formatForTailwindCSS(entry, vim_item)
						return vim_item
					end,
				}),
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		})
	end,
}
