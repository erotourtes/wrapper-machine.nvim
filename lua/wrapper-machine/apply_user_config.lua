local function apply_user_config(user_config, defaults)
    local config = vim.tbl_deep_extend("force", {}, defaults)

    if user_config then
        if user_config.keymap ~= nil then config.keymap = user_config.keymap end
        if user_config.close_symbols ~= nil then
            config.close_symbols = user_config.close_symbols
        end
        if user_config.create_commands ~= nil then
            config.create_commands = user_config.create_commands
        end
    end

    return config
end

return apply_user_config
