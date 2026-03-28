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
local GetCursorPosition = GetCursorPosition

-- Minimap button
local minimapDataObject = LDB:NewDataObject("EZMouseCircle", {
    type = "launcher",
    icon = "Interface\\Icons\\Ability_marksmanship",
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
                mouseCircle = {
                    strata = "TOOLTIP",
                    size = 32,
                    texture = "Interface\\AddOns\\EZMouseCircle\\Textures\\circle.tga",
                    color = {r = 1, g = 1, b = 1, a = 1},
                    alpha = 1,
                },
            },
        },
    }, true)

    -- Minimap button
    LDBIcon:Register("EZMouseCircle", minimapDataObject, self.db.profile.general.addon.minimap)
end

function EZMouseCircle:OnEnable()
    self:RegisterOptions()

    self:CreateMouseTexture()
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

function EZMouseCircle:CreateMouseTexture()

    if EZMouseCircle.frame then return end

    local scale = UIParent:GetEffectiveScale()

    local frame = CreateFrame("Frame", nil, UIParent)

    frame:RegisterEvent("UI_SCALE_CHANGED")
    frame:SetScript("OnEvent", function()
        print("UI_SCALE_CHANGED")
        scale = UIParent:GetEffectiveScale()
    end)

    frame:SetScript("OnUpdate", function(f)
        local x, y = GetCursorPosition()

        f:ClearAllPoints()
        f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x / scale), (y / scale))
    end)

    local texture = frame:CreateTexture(nil, "OVERLAY")
    texture:SetAllPoints()
    frame.texture = texture

    EZMouseCircle.frame = frame

    self:StyleMouseTexture()
end

function EZMouseCircle:StyleMouseTexture()
    local settings = self.db.profile.general.mouseCircle

    local frame = EZMouseCircle.frame

    frame:SetFrameStrata(settings.strata)
    frame:SetSize(settings.size, settings.size)

    frame.texture:SetTexture(settings.texture)
    frame.texture:SetVertexColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
    frame.texture:SetAlpha(settings.alpha)
end
