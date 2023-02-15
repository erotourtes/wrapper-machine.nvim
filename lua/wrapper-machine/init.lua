local set_lines = require("wrapper-machine.set_lines")

local M = {}

local defaults = {
    symbols = {},
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
}

local function init(config)
    for _, symbol in ipairs(config.symbols) do
        vim.keymap.set(
            "v",
            config.keymap .. symbol,
            function() set_lines(symbol, config) end,
            { silent = true }
        )
    end
end

local function apply_user_config(user_config)
    local config = vim.tbl_deep_extend("force", {}, defaults)

    if user_config then
        if user_config.keymap ~= nil then config.keymap = user_config.keymap end
        if user_config.close_symbols ~= nil then config.close_symbols = user_config.close_symbols end
    end

    return config
end

M.setup = function(user_config)
    local config = apply_user_config(user_config)

    for left_bracket in pairs(config.close_symbols) do
        table.insert(config.symbols, left_bracket)
    end

    init(config)
end

return M
