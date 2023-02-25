local set_lines = require("wrapper-machine.set_lines")

local function activate(config)
  for _, symbol in ipairs(config.symbols) do
    vim.keymap.set(
      "v",
      config.keymap .. symbol,
      function() set_lines(symbol, config) end,
      { silent = true }
    )
  end
end

return activate
