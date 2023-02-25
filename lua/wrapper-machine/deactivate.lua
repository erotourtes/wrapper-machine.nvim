local function deactivate(config)
  for _, symbol in ipairs(config.symbols) do
    vim.keymap.del("v", config.keymap .. symbol)
  end
end

return deactivate
