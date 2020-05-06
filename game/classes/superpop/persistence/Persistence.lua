local GGData = require "lib.GGData"
local Constants = require "classes.superpop.business.Constants"

local random = math.random

local Persistence = {}

local _NUM_THEMES = #Constants.TBL_IAP_THEMES

function Persistence:new()
    local object = {
        data = GGData:new("data"),
    }

    local rtn = setmetatable(object, {__index = Persistence})

    if object.data["nGameVersion"] == nil then
        object:clear()
    end

    return rtn
end

function Persistence:set(property, value)
    self.data:set(property, value)
    self.data:save()
end

function Persistence:get(property)
    return self.data[property]
end

function Persistence:addCoins(value)
    local numCoins = self.data["nCoins"] + value
    numCoins = numCoins < 0 and 0 or numCoins
    self.data:set("nCoins", numCoins)
    self.data:save()
end

function Persistence:getBonusThemeId()
    local tblThemeBuyed = self.data["tThemeBuyed"]
    local tblThemes = {}

    if not tblThemeBuyed["t"..string.format("%02d", Constants.NUM_FIRST_BONUS_THEME_ID)] then
        return Constants.NUM_FIRST_BONUS_THEME_ID
    end

    local isBuyed = false
    for id=1, _NUM_THEMES do
        isBuyed = self.data["tThemeBuyed"]["t"..string.format("%02d", id)]
        if isBuyed == false then
            tblThemes[#tblThemes + 1] = id
        end
    end

    if #tblThemes > 0 then
        return tblThemes[random(#tblThemes)]
    end

    return nil
end

function Persistence:updateDatabase()

    local numGameVersion = self.data["nGameVersion"]

    -- ADDED TO DATABASE AFTER FIRST RELEASE
    
    -- 25
    if numGameVersion < 22 then
        local dNow = os.date("*t") 
        dNow = os.time{year=dNow.year, month=dNow.month, day=dNow.day, hour=0, min=0, sec=0}
        self.data:set("playerID", nil)
        self.data:set("nPlayedSplash", self.data["nPlayedNormal"])
        self.data:set("nRankSplash", 0)
        self.data:set("nHighScoreSplash", self.data["nHighScoreNormal"])
        self.data:set("nHighScoreSplashToday", self.data["nHighScoreNormalToday"])
        self.data:set("dHighScoreSplashToday", self.data["dHighScoreNormalToday"])
        self.data:set("nPlayedNormal", nil)
        self.data:set("nHighScoreNormal", nil)
        self.data:set("nHighScoreNormalToday", nil)
        self.data:set("dHighScoreNormalToday", nil)
        self.data:set("nPlayedTimer", 0)
        self.data:set("nRankTimer", 0)
        self.data:set("nHighScoreTimer", 0)
        self.data:set("nHighScoreTimerToday", 0)
        self.data:set("dHighScoreTimerToday", dNow)
        self.data:set("nPlayedBomb", 0)
        self.data:set("nRankBomb", 0)
        self.data:set("nHighScoreBomb", 0)
        self.data:set("nHighScoreBombToday", 0)
        self.data:set("dHighScoreBombToday", dNow)
        self.data:set("nGameVersion", 25)

        local tblThemes = self.data["tThemeBuyed"]
        for i=6, 7 do
            local strId = "t"..string.format("%02d", i)
            tblThemes[strId] = false
        end
        self.data:set("tThemeBuyed", tblThemes)
    end

    -- 30
    if numGameVersion < 30 then
        for i=1, Constants.NUM_FRIENDS_TO_LOAD_RANKING do
            self.data:set("sAliasFriend"..i.."Splash", nil)
            self.data:set("sAliasFriend"..i.."Bomb", nil)
            self.data:set("sAliasFriend"..i.."Timer", nil)
            self.data:set("playerIDFriend"..i.."Splash", nil)
            self.data:set("playerIDFriend"..i.."Bomb", nil)
            self.data:set("playerIDFriend"..i.."Timer", nil)
            self.data:set("nRankFriend"..i.."Splash", 0)
            self.data:set("nRankFriend"..i.."Bomb", 0)
            self.data:set("nRankFriend"..i.."Timer", 0)
        end
        self.data:set("sAlias", nil)
        self.data:set("nGameVersion", 30)
    end

    -- 32
    if numGameVersion < 32 then
        self.data:set("nGameVersion", 32)
    end

    self.data:save()
end

function Persistence:clear()
    local dNow = os.date("*t") 
    dNow = os.time{year=dNow.year, month=dNow.month, day=dNow.day, hour=0, min=0, sec=0}


    self.data:delete()
    self.data = GGData:new("data")

    local tblThemes = {}
    for i=1, _NUM_THEMES do
        local strId = "t"..string.format("%02d", i)
        -- ONLY 1 AND 2 ON PRODUCTION
        if i < 3 then
            tblThemes[strId] = true
        else
            tblThemes[strId] = false
        end
    end
    self.data:set("tThemeBuyed", tblThemes)

    for i=1, Constants.NUM_FRIENDS_TO_LOAD_RANKING do
        self.data:set("sAliasFriend"..i.."Splash", nil)
        self.data:set("sAliasFriend"..i.."Bomb", nil)
        self.data:set("sAliasFriend"..i.."Timer", nil)
        self.data:set("playerIDFriend"..i.."Splash", nil)
        self.data:set("playerIDFriend"..i.."Bomb", nil)
        self.data:set("playerIDFriend"..i.."Timer", nil)
        self.data:set("nRankFriend"..i.."Splash", 0)
        self.data:set("nRankFriend"..i.."Bomb", 0)
        self.data:set("nRankFriend"..i.."Timer", 0)
    end

    self.data:set("nGameVersion", 32)
    self.data:set("nCoins", 0) -- 0 IN PRODUCTION
    self.data:set("nThemeCurrent", 1)
    self.data:set("isBeenRated", nil)
    self.data:set("isSoundActive", true)
    self.data:set("ads", true)
    self.data:set("playerID", nil)
    self.data:set("sAlias", nil)
    self.data:set("nPlayedSplash", 0)
    self.data:set("nRankSplash", 0)
    self.data:set("nHighScoreSplash", 0)
    self.data:set("nHighScoreSplashToday", 0)
    self.data:set("dHighScoreSplashToday", dNow)
    self.data:set("nPlayedTimer", 0)
    self.data:set("nRankTimer", 0)
    self.data:set("nHighScoreTimer", 0)
    self.data:set("nHighScoreTimerToday", 0)
    self.data:set("dHighScoreTimerToday", dNow)
    self.data:set("nPlayedBomb", 0)
    self.data:set("nRankBomb", 0)
    self.data:set("nHighScoreBomb", 0)
    self.data:set("nHighScoreBombToday", 0)
    self.data:set("dHighScoreBombToday", dNow)
    self.data:set("tGiftCurrent", {id=1,dActivate=0})
    self.data:set("isNotified1", false)
    self.data:set("dNotified1", nil)
    self.data:set("isNotified2", false)
    self.data:set("dNotified2", nil)
    self.data:setSync(false)
    self.data:save()
end

return Persistence