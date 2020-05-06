local Composer = require "composer"

local Controller = require "classes.superpop.business.Controller"
local Constants = require "classes.superpop.business.Constants"
local Trt = require "lib.Trt"


local random = math.random


local Util = {}

local function copyTable(self, obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[Util:copyTable(k, s)] = Util:copyTable(v, s) end
    return res
end

local function hideStatusbar()
    display.setStatusBar(display.HiddenStatusBar)
    if system.getInfo("platformName") == "Android" then
        local androidVersion = string.sub(system.getInfo("platformVersion"), 1, 3)
        if androidVersion and tonumber(androidVersion) >= 4.4 then
            native.setProperty("androidSystemUiVisibility", "immersiveSticky")
        elseif androidVersion then
            native.setProperty("androidSystemUiVisibility", "lowProfile")
        end
    end
end

-- GENERAL

local function formatNumber(self, amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then break end
    end
    return formatted
end

local masterVolume = audio.getVolume()

-- CONTROL HARD BUTTONS

local downPress = false
local function _getMasterVolume(self)
    return masterVolume
end
local tmrKeyCancel
local function _updateVolume(keyName, qtd)
    if keyName == "volumeUp" then
        masterVolume = audio.getVolume()
        if masterVolume < 1 then
            masterVolume = masterVolume + qtd
            audio.setVolume(masterVolume)
            media.setSoundVolume(masterVolume)
        else
            audio.setVolume(1)
            media.setSoundVolume(1)
        end
    elseif keyName == "volumeDown" then
        masterVolume = audio.getVolume()
        if masterVolume > .1 then
            masterVolume = masterVolume - qtd
            audio.setVolume(masterVolume)
            media.setSoundVolume(masterVolume)
        else
            audio.setVolume(0)
            media.setSoundVolume(0)
        end
    elseif keyName == "back" then
        downPress = true
    end
    tmrKeyCancel = timer.performWithDelay(30, function()
        _updateVolume(keyName, .05)
    end, 1)
end
local function _onBackKeyButtonPressed(event)
    local phase = event.phase
    local keyName = event.keyName

    if phase == "down" then
        _updateVolume(keyName, .1)
    elseif phase == "up" then
        if keyName == "back" and downPress then
            downPress = false
            if globals_btnBackRelease then
                globals_btnBackRelease({phase="ended"})
            elseif Controller:getStatus() == 0 then
                os.exit()
            end
        elseif tmrKeyCancel ~= nil then
            timer.cancel(tmrKeyCancel)
        end
    end

    if keyName == "volumeUp" or keyName == "volumeDown" then
        return false
    end

    return true
end
Runtime:addEventListener("key", _onBackKeyButtonPressed)


Util.formatNumber = formatNumber
Util.hideStatusbar = hideStatusbar
Util.copyTable = copyTable


return Util