local function bound_lines(start_pos, end_pos)
    local start_line =
        vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, start_pos[1], false)[1]
    local end_line = vim.api.nvim_buf_get_lines(0, end_pos[1] - 1, end_pos[1], false)[1]
    return {start_line, end_line}
end

return bound_lines
