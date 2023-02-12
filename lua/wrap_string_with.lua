local function wrap_string_with(symbol, line, index)
    local wraped = line:sub(1, index) .. symbol .. line:sub(index + 1, #line)
    return wraped
end

return wrap_string_with
