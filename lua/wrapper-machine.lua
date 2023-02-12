local set_single_line = require("set_single_line")
local set_multi_lines = require("set_multi_lines")
local get_pos = require("get_pos")

local M = {}

local defaults = {
    symbols = { "(", "[", "{", "<", '"', "'", "`" },
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
    local function wrap_text_with(symbol)
        local start_pos, end_pos = get_pos()

        if start_pos[1] == end_pos[1] then
            set_single_line(start_pos, end_pos, symbol, config)
        else
            set_multi_lines(start_pos, end_pos, symbol, config)
        end
    end

    for _, symbol in ipairs(config.symbols) do
        vim.keymap.set(
            "v",
            config.keymap .. symbol,
            function() wrap_text_with(symbol) end,
            { silent = true }
        )
    end
end

local function apply_user_config(user_config)
    local config = vim.tbl_deep_extend("force", {}, defaults)

    if user_config then
        if vim.tbl_islist(user_config.keymap) then config.keymap = user_config.keymap end
    end

    return config
end

M.setup = function(user_config)
    local config = apply_user_config(user_config)
    print(config)

    init(config)
end

return M
