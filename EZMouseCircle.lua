-- Create addon object and make it globally accessible
local ADDON_NAME, NS = ...

-- Library references
local LibStub = LibStub
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local EZMouseCircle = LibStub("AceAddon-3.0"):NewAddon(
    ADDON_NAME,
    "AceEvent-3.0",
    "AceConsole-3.0"
)

NS.addon = EZMouseCircle
EZMouseCircle.LDBIcon = LDBIcon

-- Localize WoW API functions


-- Minimap button
local minimapDataObject = LDB:NewDataObject("EZMouseCircle", {
    type = "launcher",
    icon = "Interface\\Icons\\Ability_Rogue_Shadowstrikes",
    OnClick = function(_, button)
        if button == "LeftButton" then
            EZMouseCircle:OpenOptions()
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("EZ Mouse Circle")
        tooltip:AddLine("Left-Click to open options.", 1, 1, 1)
    end,
})

function EZMouseCircle:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("EZMouseCircleDB", {
        profile = {
            general ={
                addon = {
                    minimap = {
                        hide = false,
                        minimapPos = 45,
                    },
                },
            },
        },
    }, true)

    -- Minimap button
    LDBIcon:Register("EZMouseCircle", minimapDataObject, self.db.profile.general.addon.minimap)
end

function EZMouseCircle:OnEnable()
    self:RegisterOptions()
end

function EZMouseCircle:OnDisable()
    self:UnregisterAllEvents()
end

function EZMouseCircle:RegisterOptions()
    local options = self:GetOptions()

    AC:RegisterOptionsTable("EZMouseCircle", options)
    ACD:AddToBlizOptions("EZMouseCircle", "EZMouseCircle")
end

-- Open/close options panel
function EZMouseCircle:OpenOptions()
    local openFrame = ACD.OpenFrames["EZMouseCircle"]

    if openFrame and openFrame.frame and openFrame.frame:IsShown() then
        -- Close options panel if already open
        ACD:Close("EZMouseCircle")
    else
        -- Open options panel
        ACD:Open("EZMouseCircle")

        -- Set options panel frame settings
        local frame = ACD.OpenFrames["EZMouseCircle"]
        frame.frame:SetClampedToScreen(true)
    end
end
