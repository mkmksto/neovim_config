# My Neovim Config

## Installation

- option 1 (best dev experience and easiest): just use the `deb` image and install using either `sudo apt install <deb file>` or `dpk install .... something`
- option 2: download the `appimage` then copy the binary to one of the `$PATH`s
- periodically run `checkhealth`
- location `nvim ~/.config/nvim/`

## Requirements

- nvim >= `0.9.1` (used `0.8.3` previously)
- git
- Installing `black`, `isort` and `pylint` can sometimes result in `unable to create python3 venv environment`. Check this [stackoverflow](https://askubuntu.com/questions/958303/unable-to-create-virtual-environment-with-python-3-6) post

### OS-level dependencies

- ripgrep `rg`
- `fd` for finding files
- fzf

(For a nice development environment)

- lazygit
- delta for lazygit and git diff viewers
- nerd fonts
- `nvm` for node version management
- `virtualenv`
- `pnpm`
- `bat` (telescope file previews)
- `glow` (md file previews)
- install `locate`
- `fd`

## Configuration (i.e. things you might need to do manually after installing)

- install a local typescript server for `vue`'s `volar takeover` mode (check `global_ts` from `lspconfig.lua`)
- for `DAP`, you might have to manually type the location of some of the adapters, e.g. for python
  - see `dap.adapters.python` under `debugging.lua`
- you might need to configure a custom location if you'd want to use a dictionary for `MD` files
- make sure your folder structure matches the repos the plugins will be setting up (e.g. telescope repo, telescope searching for notes, etc.)
- also check folder structure against `projections-nvim.lua` and `telescope`.
- install your `DAP` adapters and ensure the paths match the locations @ `debugging.lua`

## Common issues

- `;5u` appearing when i try to exit a terminal: this happens when you press `Ctrl+Enter` (sometimes i forget that i'm actually holding `ctrl` because of `ctrl+space` zsh autocomplete)
- `pylint` false positives about import error: probably has to do with `NULL LS` being confused about which `pylint` installation to use, when pylint is installed from mason, it attempts to use that, and as a result, it may try to resolve import dependencies from where the global `mason` pylint package is installed.

  - `FIX`: under `mason.lua`, comment out the part where `pylint` is under `null_ls`'s `ensure_installed` packages
  - then simply install pylint inside the venv of your project (seems to work lol idk why)

### some mason/null ls packages failing to install

check that you have unzip installed (particularly for WSL)
`spawn: unzip failed with exit code..... unzip not executable`

### Windows/WSL (check notes md files)

includes:

- install zsh first
- [main](https://www.youtube.com/watch?v=su0h5StEZ6A) installation video
- `chsh -s $(which zsh)` to change the default shell
- remaps for windows `terminal` to enable common keymaps. (like `s-space` and `c-s-p`)

#### Remaps (Windows Neovim (WSL))

##### To enable shift+space as your escape key for the windows terminal

```json
    "actions":
    [
        {
            ...
        },
	{
            "command": {
	        "action" : "sendInput",
	    	"input": "\u001b"
	    },
            "keys": "shift+space"
        }
    ],
```

##### To enable ctrl+shift+p to open telescope key maps

1. remap windows terminal's command palette to `ctrl+alt+p`
2. remove this line inside the JSON file

```json
        {
            "command": "unbound",
            "keys": "ctrl+shift+p"
        },
```

3. add this line

```json
{
  "command": {
    "action": "sendInput",
    "input": "\u001b[80;5u"
  },
  "keys": "ctrl+shift+p"
}
```

> Note: you can't write `\x1b`, apparently it's not valid JSON, you have to use `/u001b` [source](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/actions)

##### Other things you'll need to config/install manually

`lspconfig.lua` (around line 157)

- instead of hardcoding the username, check if lua/vim has functions for this
- or rather, just try using the relative path to home `~/`, if this doesn't work, try `vim.fn.expand`
- install a global TS lsp here

- search how to sync clipboard with windows if using WSL
- comment using c-/ not working
- markdown preview (not opening browser if using WSL- prob because the browser is hardcoded to a linux path)

## Snapshots

- to create snapshots, type `:PackerSnapshot <name of snap>`
- `name of snap` can be an absolute path
- for the sake of simplicity and git tracking, snapshots are saved under `./packer_snaps`, where `.` is the current directory (`~/.config/nvim/`)
- check the [docs](https://github.com/wbthomason/packer.nvim#custom-initialization) to see how to config packer to use a custon snap directory

### Important snapshots

- `02-25-2023-23-58` `(11:58PM):` unlocked all packages then resynced packer, changed from `sumneko_lua` to `lua_ls`, added more `pcalls`, added more support for `WSL`, packer bootstrap.

## Windows Setup

- config is located at `$Appdata/Local/nvim` (create a folder is none yet)
- `mklink /D link "D:\path\to\neovim\config"` (create symlink from your neovim config (in this case, located @ drive D, to where the neovim config should be located(at the appdata folder) ))
- install fzf, rg, fd
- install `zig` using chocolatey (https://stackoverflow.com/questions/75587679/neovim-treesitter-returning-no-c-complier-error), without `gcc` or `zig`, treesitter fails to install things.
