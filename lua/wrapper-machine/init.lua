local activate = require("wrapper-machine.activate")
local deactivate = require("wrapper-machine.deactivate")
local apply_user_config = require("wrapper-machine.apply_user_config")

local M = {}

local defaults = {
    symbols = {},
    close_symbols = {
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ["<"] = ">",
        ['"'] = '"',
        ["'"] = "'",
        ["`"] = "`",
    },
    keymap = "<leader>",
    create_commands = true,
}

local function init(config)
    local is_active = false

    local enable = function()
        if not is_active then
            activate(config)
            is_active = true
        end
    end

    local disable = function()
        if is_active then
            deactivate(config)
            is_active = false
        end
    end

    local toggle = function()
        if is_active then
            disable()
        else
            enable()
        end
    end

    enable()

    return enable, disable, toggle
end

M.setup = function(user_config)
    local config = apply_user_config(user_config, defaults)

    for left_bracket in pairs(config.close_symbols) do
        table.insert(config.symbols, left_bracket)
    end

    M.enable, M.disable, M.toggle = init(config)

    if config.create_commands then
        vim.api.nvim_create_user_command(
            "WrapperMachinEnable",
            function() M.enable() end,
            {}
        )
        vim.api.nvim_create_user_command(
            "WrapperMachineDisable",
            function() M.disable() end,
            {}
        )
        vim.api.nvim_create_user_command(
            "WrapperMachineToggle",
            function() M.toggle() end,
            {}
        )
    end
end

return M
