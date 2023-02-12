local wrap_string_with = require("wrap_string_with")
local bound_lines = require("bound_lines")

local function set_multi_lines(start_pos, end_pos, symbol, config)
    local start_line, end_line = bound_lines(start_pos, end_pos)

    local first_sel_ch = start_line:sub(start_pos[2] + 1, start_pos[2] + 1)
    local last_sel_ch = end_line:sub(end_pos[2] + 1, end_pos[2] + 1)

    -- unwraping if the selection is already wrapped
    for _, conf_symbol in ipairs(config.symbols) do
        if
            first_sel_ch == conf_symbol
            and last_sel_ch == config.close_symbols[conf_symbol]
        then
            start_line = start_line:sub(1, start_pos[2])
                .. start_line:sub(start_pos[2] + 2)
            end_line = end_line:sub(1, end_pos[2]) .. end_line:sub(end_pos[2] + 2)
            break
        end
    end

    if first_sel_ch ~= symbol and symbol ~= last_sel_ch then
        start_line = wrap_string_with(symbol, start_line, start_pos[2])
        end_line =
            wrap_string_with(config.close_symbols[symbol], end_line, end_pos[2] + 1)
    end

    vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, { start_line })
    vim.api.nvim_buf_set_lines(0, end_pos[1] - 1, end_pos[1], false, { end_line })
end

return set_multi_lines
