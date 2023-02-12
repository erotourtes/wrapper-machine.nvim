local M = {}

local symbols = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
    ["\""] = "\"",
    ["'"] = "'",
    ["`"] = "`",
}

local function get_pos()
    local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)

    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")

    -- when visual-line mode is on end_pos[2] will be very large number
    if (end_pos[2] > 1000000) then
        end_pos[2] = vim.api.nvim_buf_get_lines(0, end_pos[1] - 1, end_pos[1], false)[1]:len()
    end

    return start_pos, end_pos
end

local function bound_lines(start_pos, end_pos)
    local start_line = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, start_pos[1], false)[1]
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
        local wrapped_line = wrap_string_with(symbol, start_line, start_pos[2])
        wrapped_line = wrap_string_with(symbols[symbol], wrapped_line, end_pos[2] + 2)
        vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, { wrapped_line })
    end

    local function set_multi_line()
        local wrapped_start = wrap_string_with(symbol, start_line, start_pos[2])
        local wrapped_end = wrap_string_with(symbols[symbol], end_line, end_pos[2] + 1)

        vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, { wrapped_start })
        vim.api.nvim_buf_set_lines(0, end_pos[1] - 1, end_pos[1], false, { wrapped_end })
    end

    if (start_pos[1] == end_pos[1]) then
        set_one_line()
    else
        set_multi_line()
    end
end

vim.keymap.set("v", "(", function()
    print(wrap_text_with(("(")))

end, { silent = true })


M.setup = function(user_config)

end


return M
