local get_pos = require("get_pos")
local bound_lines = require("bound_lines")
local wrap_string_with = require("wrap_string_with")
local M = {}

local close_symbols = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
    ['"'] = '"',
    ["'"] = "'",
    ["`"] = "`",
}

local defaults = {
    symbols = { "(", "[", "{", "<", '"', "'", "`" },
    keymap = "<leader>",
}

local function init(config)
    local function wrap_text_with(symbol)
        local start_pos, end_pos = get_pos()
        local start_line, end_line = bound_lines(start_pos, end_pos)

        local function set_one_line()
            local first_sel_ch = start_line:sub(start_pos[2] + 1, start_pos[2] + 1)
            local last_sel_ch = start_line:sub(end_pos[2] + 1, end_pos[2] + 1)

            for _, key in ipairs(config.symbols) do
                if (first_sel_ch == key and last_sel_ch == close_symbols[key]) then
                    start_line = start_line:sub(1, start_pos[2]) .. start_line:sub(start_pos[2] + 2, end_pos[2]) .. start_line:sub(end_pos[2] + 2, #start_line)

                    if (first_sel_ch == symbol) then
                        vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, { start_line })
                        return
                    end

                    break;
                end
            end

            local wrapped_line = wrap_string_with(symbol, start_line, start_pos[2])
            wrapped_line = wrap_string_with(close_symbols[symbol], wrapped_line, end_pos[2] + 2)
            vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, { wrapped_line })
        end

        -- local function set_multi_line()
        --     local wrapped_start = wrap_string_with(symbol, start_line, start_pos[2])
        --     local wrapped_end = wrap_string_with(close_symbols[symbol], end_line, end_pos[2] + 1)
        --
        --     vim.api.nvim_buf_set_lines(
        --         0,
        --         start_pos[1] - 1,
        --         start_pos[1],
        --         false,
        --         { wrapped_start }
        --     )
        --     vim.api.nvim_buf_set_lines(0, end_pos[1] - 1, end_pos[1], false, { wrapped_end })
        -- end

        if start_pos[1] == end_pos[1] then
            set_one_line()
        else
            -- set_multi_line()
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
