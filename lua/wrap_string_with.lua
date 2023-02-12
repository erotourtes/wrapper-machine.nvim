local function wrap_string_with(symbol, line, index)
    local wrapped = line:sub(1, index) .. symbol .. line:sub(index + 1, #line)
    return wrapped
end

return wrap_string_with
