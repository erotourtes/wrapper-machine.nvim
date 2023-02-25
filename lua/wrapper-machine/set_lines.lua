local wrap_string_with = require("wrapper-machine.wrap_string_with")
local bound_lines = require("wrapper-machine.bound_lines")
local get_pos = require("wrapper-machine.get_pos")

local function set_lines(symbol, config)
    local start_pos, end_pos = get_pos()

    local lines = bound_lines(start_pos, end_pos)
    local start_line, end_line = 1, 2

    if start_pos[1] == end_pos[1] then end_line = 1 end

    -- offset for the case when the selection is already wrapped
    local offset = 0

    local first_sel_ch = lines[start_line]:sub(start_pos[2] + 1, start_pos[2] + 1)
    local last_sel_ch = lines[end_line]:sub(end_pos[2] + 1, end_pos[2] + 1)

    -- unwrapping if the selection is already wrapped
    for _, conf_symbol in ipairs(config.symbols) do
        if
            first_sel_ch == conf_symbol
            and last_sel_ch == config.close_symbols[conf_symbol]
        then
            lines[end_line] = lines[end_line]:sub(1, end_pos[2])
                .. lines[end_line]:sub(end_pos[2] + 2)
            lines[start_line] = lines[start_line]:sub(1, start_pos[2])
                .. lines[start_line]:sub(start_pos[2] + 2)
            offset = -2
            break
        end
    end

    if first_sel_ch ~= symbol and symbol ~= last_sel_ch then
        lines[end_line] = wrap_string_with(
            config.close_symbols[symbol],
            lines[end_line],
            end_pos[2] + 1 + offset
        )
        lines[start_line] = wrap_string_with(symbol, lines[start_line], start_pos[2])
    end

    vim.api.nvim_buf_set_lines(
        0,
        start_pos[1] - 1,
        start_pos[1],
        false,
        { lines[start_line] }
    )
    vim.api.nvim_buf_set_lines(0, end_pos[1] - 1, end_pos[1], false, { lines[end_line] })
end

return set_lines
