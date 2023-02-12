local function get_pos()
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)

    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")

    -- when visual-line mode is on end_pos[2] will be very large number
    if end_pos[2] > 1000000 then
        end_pos[2] = vim.api
            .nvim_buf_get_lines(0, end_pos[1] - 1, end_pos[1], false)[1]
            :len() - 1
    end

    return start_pos, end_pos
end

return get_pos
