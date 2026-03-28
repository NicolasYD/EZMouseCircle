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

                    mouseCircle = {
                        type = "group",
                        name = "Mouse Circle",
                        inline = true,
                        order = 20,
                        args = {
                            color = {
                                type = "color",
                                name = "Color",
                                desc = "Pick the color of the mouse circle",
                                hasAlpha = true,
                                order = 10,
                                get = function(_)
                                    local color = EZMouseCircle.db.profile.general.mouseCircle.color
                                    return color.r, color.g, color.b, color.a
                                end,
                                set = function(_, r, g, b, a)
                                    local color = EZMouseCircle.db.profile.general.mouseCircle.color
                                    color.r, color.g, color.b, color.a = r, g, b, a

                                    EZMouseCircle:StyleMouseTexture()
                                end,
                            },
                            separator1 = {
                                type = "description",
                                name = "",
                                width = "full",
                                order = 11
                            },
                            size = {
                                type = "range",
                                name = "Size",
                                desc = "Change the size of the mouse circle.",
                                min = 0,
                                max = 200,
                                step = 1,
                                order = 20,
                                get = function(_)
                                    return settings.general.mouseCircle.size
                                end,
                                set = function(_, value)
                                    settings.general.mouseCircle.size = value

                                    EZMouseCircle:StyleMouseTexture()
                                end,
                            },
                            separator2 = {
                                type = "description",
                                name = "",
                                width = "full",
                                order = 21
                            },
                        },
                    },
                },
            },
        },
    }
end
