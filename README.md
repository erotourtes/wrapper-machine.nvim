# wrapper-machine.nvim
A plugin that automatically opens and closes brackets and quotes.

[example.webm](https://user-images.githubusercontent.com/67370189/219101314-2ab2029f-3e19-44c7-a059-cbec5f51ec68.webm)

## Getting Started

### Installation

[Neovim >=0.8.0](https://github.com/neovim/neovim/releases/tag/v0.8.0) is recommended.

The plugin can be installed using any plugin manager. An example using
[packer.nvim:](https://github.com/wbthomason/packer.nvim):

```lua
use({ "erotourtes/wrapper-machine.nvim", tag = "1.0.0" })
```

### Usage

In order to use the plugin, it is required to call `setup()`. The following line will use default settings:

```lua
require("wrapper-machine").setup()
```

The default configuration options:

```lua
require("wrapper-machine").setup({
  close_symbols = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
    ['"'] = '"',
    ["'"] = "'",
    ["`"] = "`",
  },
  keymap = "<leader>",
})

```

In order to wrap something press your keymap and an opening bracket in visual mode.

For more information read [help](./doc/wrapper-machine.txt) `:h wrapper-machine.nvim`.
