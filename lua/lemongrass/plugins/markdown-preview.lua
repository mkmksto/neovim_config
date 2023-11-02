return {
	"iamcco/markdown-preview.nvim",
	event = "BufRead",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		local is_linux = vim.loop.os_uname().sysname == "Linux"
		-- https://www.reddit.com/r/neovim/comments/vr68yl/checking_for_wsl_in_initlua/
		local is_wsl = (function()
			local output = vim.fn.systemlist("uname -r")
			return not not string.find(output[1] or "", "WSL")
		end)()

		if is_wsl then
			vim.cmd([[
                function OpenMarkdownPreview (url)
                  silent exec '!"C:/Program Files (x86)/Google/Chrome/Application/chrome.exe" --new-window ' . a:url . " &"
                endfunction
            ]])

			-- vim.g.mkdp_browser = "C:/Program Files/Mozilla Firefox/firefox.exe"
			vim.g.mkdp_browser = "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
			vim.g.mkdp_theme = "light"
		elseif is_linux then
			--
			-- https://github.com/iamcco/markdown-preview.nvim/issues/19
			-- https://github.com/iamcco/markdown-preview.nvim/issues/262
			vim.cmd([[
                function OpenMarkdownPreview (url)
                  silent exec "!google-chrome --new-window " . a:url . " &"
                endfunction
            ]])
			-- TODO: check if this works
			-- vim.g.mkdp_browser = "/usr/bin/epiphany"
			vim.g.mkdp_browser = "google-chrome"
			vim.g.mkdp_theme = "light"
			vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
		end
	end,
}
