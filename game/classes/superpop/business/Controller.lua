local Composer = require "composer"

local Notifier = require "classes.superpop.business.Notifier"
local GameNetwork = require "gameNetwork"
local Constants = require "classes.superpop.business.Constants"
local AdsGame = require "classes.superpop.business.AdsGame"


local Controller = {}


local random = math.random

-- STATUS  0:menu, 1:playing, 2:paused, 3:results
local _TBL_STATUS_FLOW = {
    {1},    -- 0
    {2, 3}, -- 1
    {0, 1}, -- 2
    {0},    -- 3
}

local _TBL_GAMEMODES = {
    "Splash",
    "Bomb",
    "Timer"
}
Controller.TBL_GAMEMODES = _TBL_GAMEMODES

local function init(self)
    self.status = 0

    self.numThemeId = globals_persistence:get("nThemeCurrent")

    local infTheme = require("classes.superpop.sprites.theme"..self.numThemeId)
    self.shtTheme = graphics.newImageSheet("images/theme"..self.numThemeId..".png", infTheme:getSheet())

    local infThemeScenario = require("classes.superpop.sprites.themeScenario"..self.numThemeId)
    self.shtThemeScenario = graphics.newImageSheet("images/themeScenario"..self.numThemeId..".png", infThemeScenario:getSheet())
end

local function setTheme(self, numThemeId)
    globals_persistence:set("nThemeCurrent", numThemeId)

    -- RE INIT
    self.status = 0

    self.numThemeId = numThemeId

    local infTheme = require("classes.superpop.sprites.theme"..numThemeId)
    self.shtTheme = graphics.newImageSheet("images/theme"..numThemeId..".png", infTheme:getSheet())

    local infThemeScenario = require("classes.superpop.sprites.themeScenario"..numThemeId)
    self.shtThemeScenario = graphics.newImageSheet("images/themeScenario"..numThemeId..".png", infThemeScenario:getSheet())
end

local function getSheet(self)
    return self.shtTheme
end

local function getThemeId(self)
    return self.numThemeId
end

local function getSheetScenario(self)
    return self.shtThemeScenario
end

local function hideOverlay(self, numTime)
    local strSceneOverlay = Composer.getSceneName("overlay")
    if strSceneOverlay == "classes.superpop.controller.gamemodes.SplashResults" or  
       strSceneOverlay == "classes.superpop.controller.gamemodes.TimerResults" or  
       strSceneOverlay == "classes.superpop.controller.gamemodes.BombResults" then
        return false
    end

    Composer.hideOverlay(false, "fade", numTime)
    return true
end

local function validateNextStatus(self, status)
    local tblStatus = _TBL_STATUS_FLOW[self.status + 1]
    if status ~= self.status then
        for i=1, #tblStatus do
            if status == tblStatus[i] then
                return true
            end
        end
    end
    --print(self.status, status, false)
    return false
end

local function setStatus(self, status, isForced)
    --print(self.status, "-- >", status)
    if status ~= self.status then
        if not isForced and not self:validateNextStatus(status) then
            return false
        end
        --if isForced then print(self.status, status, true) end
    end

    self.status = status
    return true
end

local function getStatus(self)
    return self.status
end

local function _syncScore(event, params)
    if event and event.data and event.data.playerID then
        local numPlayerID = event.data.playerID
        local gameMode = params.gameMode

        -- SAVING ID
        globals_persistence:set("playerID", numPlayerID)

        local _loadPlayers = function(evt)
            if evt and evt.data then
                local tblPlayers = evt.data
                for i=1, #tblPlayers do
                    if tblPlayers[i].playerID == numPlayerID then
                        globals_persistence:set("sAlias", tblPlayers[i].alias)
                    else
                        for k=1, Constants.NUM_FRIENDS_TO_LOAD_RANKING do
                            if tblPlayers[i].playerID == globals_persistence:get("playerIDFriend"..k..gameMode) then
                                globals_persistence:set("sAliasFriend"..k..gameMode, tblPlayers[i].alias)
                            end
                        end
                    end           
                end
            end
        end

        local _loadScore = function() end

        local _loadScoreCallback = function(evt)
            local nScoreGameNetwork = 0
            local nRankGameNetwork = 0

            -- RESET FRIENDS
            for i=1, Constants.NUM_FRIENDS_TO_LOAD_RANKING do
                globals_persistence:set("sAliasFriend"..i..gameMode, nil)
                globals_persistence:set("playerIDFriend"..i..gameMode, nil)
                globals_persistence:set("nRankFriend"..i..gameMode, 0)
            end

            if evt and evt.data then
                local tblPlayers = evt.data
                local nCountFriend = 1
                for i=1, #tblPlayers do
                    if tblPlayers[i].playerID == numPlayerID then
                        nScoreGameNetwork = tblPlayers[i].value
                        nRankGameNetwork = tblPlayers[i].rank
                    else
                        globals_persistence:set("nRankFriend"..nCountFriend..gameMode, tblPlayers[i].rank)
                        globals_persistence:set("playerIDFriend"..nCountFriend..gameMode, tblPlayers[i].playerID)
                        nCountFriend = nCountFriend + 1
                    end           
                end

                local tblPlayersIDs = { globals_persistence:get("playerID") }
                for i=1, Constants.NUM_FRIENDS_TO_LOAD_RANKING do
                    local id = globals_persistence:get("playerIDFriend"..i..gameMode)
                    if id and id ~= numPlayerID then
                        tblPlayersIDs[#tblPlayersIDs+1] = id
                    end
                end
                if #tblPlayersIDs == 1 then
                    _loadScore({playerScope="Global"})
                else
                    GameNetwork.request("loadPlayers", {
                        playerIDs = tblPlayersIDs,
                        listener = _loadPlayers
                    })
                end
            end

            -- SAVING
            globals_persistence:set("nRank"..gameMode, nRankGameNetwork)
            local nScore = globals_persistence:get("nHighScore"..gameMode)
            if nScoreGameNetwork > nScore then
                globals_persistence:set("nHighScore"..gameMode, nScoreGameNetwork)
            else
                GameNetwork.request("setHighScore", {
                    localPlayerScore = {category=Constants.TBL_IDS_SCORES_NETWORK[gameMode], value=nScore},
                    listener = function(event) end
                })
            end
            return true
        end

        _loadScore = function(params)
            -- print(params.playerScope)
            GameNetwork.request("loadScores", {
                    leaderboard = {
                        category = Constants.TBL_IDS_SCORES_NETWORK[gameMode],
                        playerScope = params.playerScope,
                        timeScope = "AllTime",
                        range = {1,Constants.NUM_FRIENDS_TO_LOAD_RANKING+1},
                        playerCentered = true,
                    },
                    listener = _loadScoreCallback
                }
            )
        end
        _loadScore({playerScope="FriendsOnly"})
    end
end

local syncScore = function() end
local _gameNetworkLoginCallback = function() end
local _gpgsInitCallback = function() end
local _gameNetworkSetup = function() end

syncScore = function(params)
    if system.getInfo("platformName") == "Android" and not GameNetwork.request("isConnected") then
        return
    else
        GameNetwork.request("loadLocalPlayer", {
            listener = function(event)
                _syncScore(event, params)
            end
        })
    end
end

_gameNetworkLoginCallback = function(event)
    if event == nil or (event.data and event.data.isError) then
        return
    end

    syncScore({gameMode="Splash"})
    syncScore({gameMode="Bomb"})
    syncScore({gameMode="Timer"})
end

_gpgsInitCallback = function(event)
    if event and event.isError then
        GameNetwork.request("logout")
    end
    GameNetwork.request("login", {userInitiated=true, listener=_gameNetworkLoginCallback})
end

_gameNetworkSetup = function()
    if system.getInfo("platformName") == "Android" then
        GameNetwork.init("google", _gpgsInitCallback)
    elseif system.getInfo("platformName") == "iPhone OS" then
        GameNetwork.init("gamecenter", _gameNetworkLoginCallback)
    end
end

local function systemEvents(event)
    if event then
        if event.type == "applicationStart" or event.type == "applicationResume" then
            if system.getInfo("platformName") == "iPhone OS" then
                native.setProperty("applicationIconBadgeNumber", 0)
            end
        end

        if event.type == "applicationExit" then
            Notifier:schedule(1)
        end

        if event.type == "applicationStart" then
            _gameNetworkSetup()
        end
    end

    return true
end
Runtime:addEventListener("system", systemEvents)

local function updateScore(self, params)
    local nScore = params.nScore
    local gameMode = params.gameMode

    local isScoreHigh = false
    local isScoreHighToday = false

    if nScore > globals_persistence:get("nHighScore"..gameMode) then
        globals_persistence:set("nHighScore"..gameMode, nScore)
        isScoreHigh = true
    end

    local dnow = os.date("*t") 
    local tTod = os.time{year=dnow.year, month=dnow.month, day=dnow.day, hour=0, min=0, sec=0}
    local tRec = globals_persistence:get("dHighScore"..gameMode.."Today")
    local diff = os.difftime(tTod, tRec)

    if nScore > globals_persistence:get("nHighScore"..gameMode.."Today") or (diff >= 86400 or diff < 0) then
        globals_persistence:set("dHighScore"..gameMode.."Today", tTod)
        globals_persistence:set("nHighScore"..gameMode.."Today", nScore)
        isScoreHighToday = true
    end

    syncScore({gameMode=gameMode})

    return isScoreHigh, isScoreHighToday
end

local function goNextSceneVerifyingAdsRate(self, params)
    local nPlayed = 0
    for i=1, #_TBL_GAMEMODES do
        local strMode = "nPlayed".._TBL_GAMEMODES[i]
        nPlayed = nPlayed + globals_persistence:get(strMode)
    end

    local options = {
        effect = "fade",
        time = 0,
        params = params
    }

    local _goNextScene = function() 
        Composer.stage.alpha = 0
        Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", options)
    end

    globals_adCallbackListener = function(params)
        phase = params.phase
        if phase == "hidden" or phase == "bug" then
            _goNextScene()
            globals_adCallbackListener = function() end
        end
    end

    -- SHOW RATE
    if random(2) == 1 and nPlayed % Constants.NUM_GAMES_PLAYED_TO_ASK_RATE_US == 0 and not globals_persistence:get("isBeenRated") then
        local RateIt = require "classes.superpop.controller.animations.RateIt"
        options.params.grpView = params.view
        local rateIt = RateIt:new(options)

    -- SHOW ADS
    elseif nPlayed % Constants.NUM_GAMES_PLAYED_TO_SHOW_AD == 0 and globals_persistence:get("ads") then
        local isShowingAd = AdsGame:show()
        if not isShowingAd then
            _goNextScene()
        end

    -- GO NEXT SCENE
    else
        _goNextScene()
    end
end


Controller.init = init
Controller.hideOverlay = hideOverlay
Controller.setTheme = setTheme
Controller.getThemeId = getThemeId
Controller.getSheet = getSheet
Controller.getSheetScenario = getSheetScenario
Controller.validateNextStatus = validateNextStatus
Controller.setStatus = setStatus
Controller.getStatus = getStatus
Controller.updateScore = updateScore
Controller.goNextSceneVerifyingAdsRate = goNextSceneVerifyingAdsRate


return Controller