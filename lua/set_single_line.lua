local wrap_string_with = require("wrap_string_with")
local bound_lines = require("bound_lines")

local function set_single_line(start_pos, end_pos, symbol, config)
    local line, _ = bound_lines(start_pos, end_pos)

    local first_sel_ch = line:sub(start_pos[2] + 1, start_pos[2] + 1)
    local last_sel_ch = line:sub(end_pos[2] + 1, end_pos[2] + 1)

    -- Unwrap if the selection is already wrapped
    for _, key in ipairs(config.symbols) do
        if first_sel_ch == key and last_sel_ch == config.close_symbols[key] then
            line = line:sub(1, start_pos[2])
                .. line:sub(start_pos[2] + 2, end_pos[2])
                .. line:sub(end_pos[2] + 2, #line)
            break
        end
    end

    if first_sel_ch ~= symbol and symbol ~= last_sel_ch then
        line = wrap_string_with(symbol, line, start_pos[2])
        line = wrap_string_with(config.close_symbols[symbol], line, end_pos[2] + 2)
    end

    vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, { line })
end

return set_single_line
