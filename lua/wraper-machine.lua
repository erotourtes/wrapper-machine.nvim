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

local function get_pos()
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)

    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")

    -- when visual-line mode is on end_pos[2] will be very large number
    if end_pos[2] > 1000000 then
        end_pos[2] = vim.api.nvim_buf_get_lines(0, end_pos[1] - 1, end_pos[1], false)[1]:len()
    end

    return start_pos, end_pos
end

local function bound_lines(start_pos, end_pos)
    local start_line =
    vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, start_pos[1], false)[1]
    local end_line = vim.api.nvim_buf_get_lines(0, end_pos[1] - 1, end_pos[1], false)[1]
    return start_line, end_line
end

local function wrap_string_with(symbol, line, index)
    local wraped = line:sub(1, index) .. symbol .. line:sub(index + 1, #line)
    return wraped
end

local function wrap_text_with(symbol)
    local start_pos, end_pos = get_pos()
    local start_line, end_line = bound_lines(start_pos, end_pos)

    local function set_one_line()
        local first_sel_ch = start_line:sub(start_pos[2] + 1, start_pos[2] + 1)
        local last_sel_ch = start_line:sub(end_pos[2] + 1, end_pos[2] + 1)

        if (first_sel_ch == symbol and last_sel_ch == close_symbols[symbol]) then
            local unwrapped_line = start_line:sub(1, start_pos[2]) .. start_line:sub(start_pos[2] + 2, end_pos[2]) .. start_line:sub(end_pos[2] + 2, #start_line)
            vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, { unwrapped_line })
            return
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

local function init(config)
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
