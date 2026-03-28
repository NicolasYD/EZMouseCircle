local ADDON_NAME, NS = ...
local EZMouseCircle = NS.addon

function EZMouseCircle:GetOptions()
    local settings = self.db.profile

    return {
        type = "group",
        name = "EZ Mouse Circle",
        args = {
            general = {
                type = "group",
                name = "General",
                order = 20,
                args = {
                    addon = {
                        type = "group",
                        name = "Addon",
                        inline = true,
                        order = 10,
                        args = {
                            minimap = {
                                type = "toggle",
                                name = "Minimap Button",
                                desc = "Show the minimap button.",
                                width = "full",
                                order = 10,
                                get = function()
                                    return not settings.general.addon.minimap.hide
                                end,
                                set = function(_, value)
                                    settings.general.addon.minimap.hide = not value
                                    if value then
                                        EZMouseCircle.LDBIcon:Show("EZMouseCircle")
                                    else
                                        EZMouseCircle.LDBIcon:Hide("EZMouseCircle")
                                    end
                                end,
                            },
                        },
                    },
                },
            },
        },
    }
end
