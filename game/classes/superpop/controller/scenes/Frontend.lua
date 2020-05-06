local Composer = require "composer"
local objScene = Composer.newScene()


local Widget = require "widget"


local random = math.random


local Controller = require "classes.superpop.business.Controller"
local Constants = require "classes.superpop.business.Constants"
local Scenario = require "classes.superpop.entities.Scenario"
local Jukebox = require "classes.superpop.business.Jukebox"
local Banner = require "classes.superpop.controller.animations.Banner"


local Trt = require "lib.Trt"


local scenario
local gamemode
local btnPlayChooseEvent


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


function objScene:create(event)
    local grpView = self.view
    grpView.isVisible = false
    grpView.params = event.params


    scenario = Scenario:new()
    grpView:insert(scenario)


    local grpHud = display.newGroup()
    grpView:insert(grpHud)


    local function btnFacebookEvent( event )
        if "ended" == event.phase then
            local isSoundActive = not globals_persistence:get("isSoundActive")
            system.openURL(Constants.STR_URL_FACEBOOK_PAGE)
        end
        return true
    end
    local bntFacebook = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 78,
        overFrame = 79,
        onEvent = btnFacebookEvent
    }
    grpHud:insert(bntFacebook)
    bntFacebook.anchorX, bntFacebook.anchorY = .5, .5
    bntFacebook.x, bntFacebook.y = Constants.LEFT + bntFacebook.width - 15, Constants.TOP + bntFacebook.height - 10
    bntFacebook:scale(.001, .001)
    transition.to(bntFacebook, {xScale=1, yScale=1, delay=100, time=900, transition=easing.outElastic})


    local function btnTwitterEvent( event )
        if "ended" == event.phase then
            local isSoundActive = not globals_persistence:get("isSoundActive")
            system.openURL(Constants.STR_URL_TWITTER_ACCOUNT)
        end
        return true
    end
    local bntTwitter = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 80,
        overFrame = 81,
        onEvent = btnTwitterEvent
    }
    grpHud:insert(bntTwitter)
    bntTwitter.anchorX, bntTwitter.anchorY = .5, .5
    bntTwitter.x, bntTwitter.y = Constants.RIGHT - bntTwitter.width + 15, Constants.TOP + bntTwitter.height - 10
    bntTwitter:scale(.001, .001)
    transition.to(bntTwitter, {xScale=1, yScale=1, delay=100, time=900, transition=easing.outElastic})


    Banner:Create({grpView=grpHud})


    local _onRctBgTouch = function(self, event)
        return true
    end
    local rctBg = display.newRect(grpHud, -10, -10, 350, 500)
    rctBg.anchorX, rctBg.anchorY = 0, 0
    rctBg:setFillColor(0, .8)
    rctBg.touch = _onRctBgTouch
    rctBg:addEventListener("touch", rctBg)
    rctBg.alpha = 0


    local grpMenu = display.newGroup()
    grpHud:insert(grpMenu)


    local _doAnimeLogo = function(self)
        if self.TRT_CANCEL ~= nil then
            transition.cancel(self.TRT_CANCEL)
            self.TRT_CANCEL = nil
        end
        self.TRT_CANCEL = transition.to(self, {xScale=.4, yScale=.4, time=150, transition=easing.outExpo, onComplete=function()
            Jukebox:dispatchEvent({name="playSound", id="coil"})
            self.TRT_CANCEL = transition.to(self, {xScale=1, yScale=1, time=600, transition=easing.outElastic})
        end})
    end
    local _onTouchLogo = function(self, event)
        local phase = event.phase
        if phase == "began" then
            self:doAnimeLogo()
        end
        return true
    end 
    local sptLogo = display.newSprite(_SHT_UTIL, { {name="s", start=228, count=1} })
    sptLogo.anchorX, sptLogo.anchorY = .5, .5
    sptLogo.x, sptLogo.y  = display.contentCenterX, Constants.TOP + sptLogo.height * .5 + 30
    sptLogo:scale(.001, .001)
    sptLogo.doAnimeLogo = _doAnimeLogo
    sptLogo.doMoveLogo = _doMoveLogo
    sptLogo.touch = _onTouchLogo
    sptLogo:addEventListener("touch", sptLogo)
    grpHud:insert(sptLogo)
    sptLogo:toBack()
    transition.to(sptLogo, {xScale=1, yScale=1, delay=100, time=900, transition=easing.outElastic})
    transition.to(sptLogo, {time=300, onComplete=function()
        Jukebox:dispatchEvent({name="playSound", id="coil"})
    end})

    local btnSoundOn
    local btnSoundOff
    local function btnSoundEvent( event )
        if "ended" == event.phase then
            local isSoundActive = not globals_persistence:get("isSoundActive")
            globals_persistence:set("isSoundActive", isSoundActive)
            Jukebox:activateSounds(isSoundActive)

            btnSoundOn.isVisible = isSoundActive
            btnSoundOff.isVisible = not isSoundActive

            Jukebox:dispatchEvent({name="playMusic", id=1, status=0})
            Jukebox:dispatchEvent({name="playSound", id="button"})
        end
        return true
    end
    btnSoundOn = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 47,
        overFrame = 48,
        onEvent = btnSoundEvent
    }
    btnSoundOn.anchorX, btnSoundOn.anchorY = .5, .5
    btnSoundOn.x, btnSoundOn.y = -75, 0
    btnSoundOn.isVisible = globals_persistence:get("isSoundActive")
    btnSoundOn:scale(.001, .001)
    transition.to(btnSoundOn, {xScale=1, yScale=1, delay=300, time=600, transition=easing.outElastic})
    grpMenu:insert(btnSoundOn)
    btnSoundOff = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 48,
        overFrame = 47,
        onEvent = btnSoundEvent
    }
    btnSoundOff.anchorX, btnSoundOff.anchorY = .5, .5
    btnSoundOff.x, btnSoundOff.y = -75, 0
    btnSoundOff.isVisible = not globals_persistence:get("isSoundActive")
    btnSoundOff:scale(.001, .001)
    transition.to(btnSoundOff, {xScale=1, yScale=1, delay=200, time=600, transition=easing.outElastic})
    grpMenu:insert(btnSoundOff)



    local grpConfig = display.newGroup()
    local _rotateConfig = function() end
    _rotateConfig = function()
        if grpConfig and grpConfig[2] then
            if grpConfig._TRT_CANCEL ~= nil then
                transition.cancel(grpConfig._TRT_CANCEL)
                grpConfig._TRT_CANCEL = nil
            end
            grpConfig._TRT_CANCEL = transition.to(grpConfig, {xScale=.85, yScale=.85, time=400, onComplete=function()
                grpConfig._TRT_CANCEL = transition.to(grpConfig, {xScale=1, yScale=1, time=400, onComplete=function()
                    grpConfig._TRT_CANCEL = transition.to(grpConfig, {xScale=.85, yScale=.85, time=400, onComplete=function()
                        grpConfig._TRT_CANCEL = transition.to(grpConfig, {xScale=1, yScale=1, time=400})
                    end})
                end})
            end})

            local spt = grpConfig[2]
            if spt._TRT_CANCEL ~= nil then
                transition.cancel(spt._TRT_CANCEL)
                spt._TRT_CANCEL = nil
            end
            spt._TRT_CANCEL = transition.to(spt, {rotation=spt.rotation+180, delay=400, time=1200, transition=easing.outExpo, onComplete=function()
                _rotateConfig()
            end})
        end
    end
    local function btnConfigEvent(event)
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})
            local options = {
                isModal = true,
                effect = "fade",
                time = 0,
            }
            Composer.showOverlay("classes.superpop.controller.scenes.Options", options)
        end
        return true
    end
    local btnConfig = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 53,
        overFrame = 54,
        onEvent = btnConfigEvent
    }
    btnConfig.anchorX, btnConfig.anchorY = .5, .5
    btnConfig.x, btnConfig.y = 0, 0
    grpConfig:insert(btnConfig)
    local sptConfig = display.newSprite(_SHT_UTIL, { {name="standard", frames={62} } })
    sptConfig.anchorX, sptConfig.anchorY = .5, .5
    sptConfig.x, sptConfig.y = 0, 0
    grpConfig:insert(sptConfig)
    grpConfig.anchorX, grpConfig.anchorY = .5, .5
    grpConfig.x, grpConfig.y = 75, 0
    grpConfig:scale(.001, .001)
    transition.to(grpConfig, {xScale=1, yScale=1, delay=400, time=600, transition=easing.outElastic, onComplete=function()
        _rotateConfig()
    end})
    grpMenu:insert(grpConfig)



    local Ranking = require "classes.superpop.controller.animations.Ranking"
    local _btnGameNetworkEvent = function(event)
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})
            local GameNetwork = require "gameNetwork"
            GameNetwork.show("leaderboards")
        end
    end
    local tblRankingXPositions = {-85, 0, 85}
    local grpRanks = display.newGroup()
    grpMenu:insert(grpRanks)
    grpRanks.anchorX, grpRanks.anchorY = .5, 0
    grpRanks.x, grpRanks.y = 0, -80
    for i=1, #Controller.TBL_GAMEMODES do
        local grpRank = Ranking:new({isHorizontal=false, gameMode=Controller.TBL_GAMEMODES[i]})
        grpRank.anchorX, grpRank.anchorY = .5, 0
        grpRank.x, grpRank.y, grpRank.alpha = tblRankingXPositions[i], 0, 0
        grpRank.touch = function(self, event) _btnGameNetworkEvent(event) end
        grpRank:addEventListener("touch", grpRank)
        grpRanks:insert(grpRank)
    end



    btnPlayChooseEvent = function(event)
        if "ended" == event.phase then
            if event.isInit == nil then
                Jukebox:dispatchEvent({name="playSound", id="button"})
            end

            grpView:remove(grpHud)
            grpHud = nil
            
            local Gamemode = require("classes.superpop.controller.gamemodes."..event.target.mode)
            gamemode = Gamemode:new({grpView=grpView, scenario=scenario, isInit=event.isInit == nil})
        end
        return true
    end

    local btnSplash = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 70,
        overFrame = 71,
        onEvent = btnPlayChooseEvent
    }
    btnSplash.anchorX, btnSplash.anchorY = .5, .5
    btnSplash.mode = "Splash"
    btnSplash.x, btnSplash.y = 0, 0
    btnSplash:scale(.001, .001)
    grpMenu:insert(btnSplash)

    local btnTimer = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 72,
        overFrame = 73,
        onEvent = btnPlayChooseEvent
    }
    btnTimer.anchorX, btnTimer.anchorY = .5, .5
    btnTimer.mode = "Timer"
    btnTimer.x, btnTimer.y = 0, 0
    btnTimer:scale(.001, .001)
    grpMenu:insert(btnTimer)

    local btnBomb = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 74,
        overFrame = 75,
        onEvent = btnPlayChooseEvent
    }
    btnBomb.anchorX, btnBomb.anchorY = .5, .5
    btnBomb.mode = "Bomb"
    btnBomb.x, btnBomb.y = 0, 0
    btnBomb:scale(.001, .001)
    grpMenu:insert(btnBomb)



    local btnPlay = {}
    local btnBack = {}
    local btnGameNetwork = {}


    local btnBackRelease = function(event)
        if (event == nil or "ended" == event.phase) and btnBack and btnBack.alpha == 1 then
            transition.to(btnSplash, {x=0, xScale=.001, yScale=.001, alpha=0, y=0, delay=0, time=300, transition=easing.outExpo})
            transition.to(btnBomb, {x=0, xScale=.001, yScale=.001, alpha=0, y=0, delay=100, time=300, transition=easing.outExpo})
            transition.to(btnTimer, {x=0, xScale=.001, yScale=.001, alpha=0, y=0, delay=200, time=300, transition=easing.outExpo})
            btnBack.alpha = 0
            btnGameNetwork.alpha = 0

            for i=1, grpRanks.numChildren do
                if grpRanks[i]._TRT_CANCEL ~= nil then
                    transition.cancel(grpRanks[i]._TRT_CANCEL)
                    grpRanks[i]._TRT_CANCEL = nil
                end
                grpRanks[i].alpha = 0
            end

            _rotateConfig()
            transition.to(btnPlay, {xScale=1, yScale=1, alpha=1, delay=150, time=600, transition=easing.outElastic})
            transition.to(btnSoundOn, {xScale=1, yScale=1, alpha=1, delay=200, time=600, transition=easing.outElastic})
            transition.to(btnSoundOff, {xScale=1, yScale=1, alpha=1, delay=200, time=600, transition=easing.outElastic})
            transition.to(grpConfig, {xScale=1, yScale=1, alpha=1, delay=200, time=600, transition=easing.outElastic})
            transition.to(rctBg, {alpha=0, time=400})

            Jukebox:dispatchEvent({name="playSound", id="button"})

            globals_btnBackRelease = nil
        end
        return true
    end

    local btnPlayEvent = function(event)
        if "ended" == event.phase and btnPlay.xScale == 1 then
            transition.to(btnSplash, {x=-85, xScale=1, yScale=1, alpha=1, y=-125, delay=0, time=600, transition=easing.outElastic})
            transition.to(btnBomb, {x=0, xScale=1, yScale=1, alpha=1, y=-125, delay=100, time=600, transition=easing.outElastic})
            transition.to(btnTimer, {x=85, xScale=1, yScale=1, alpha=1, y=-125, delay=200, time=600, transition=easing.outElastic})
            transition.to(btnBack, {alpha=1, delay=500, time=400})
            transition.to(btnGameNetwork, {alpha=1, delay=500, time=400})

            for i=1, grpRanks.numChildren do
                if grpRanks[i]._TRT_CANCEL ~= nil then
                    transition.cancel(grpRanks[i]._TRT_CANCEL)
                    grpRanks[i]._TRT_CANCEL = nil
                end
                grpRanks[i].y, grpRanks[i].alpha = -50, 0
                grpRanks[i]._TRT_CANCEL = transition.to(grpRanks[i], {alpha=1, delay=1000 + i * 100, time=500, y=0, transition=easing.outBack})
            end

            if grpConfig._TRT_CANCEL ~= nil then
                transition.cancel(grpConfig._TRT_CANCEL)
                grpConfig._TRT_CANCEL = nil
            end
            local spt = grpConfig[2]
            if spt._TRT_CANCEL ~= nil then
                transition.cancel(spt._TRT_CANCEL)
                spt._TRT_CANCEL = nil
            end
            transition.to(btnPlay, {xScale=.001, yScale=.001, alpha=0, time=300, transition=easing.outExpo})
            transition.to(btnSoundOn, {xScale=.001, yScale=.001, alpha=0, time=300, transition=easing.outExpo})
            transition.to(btnSoundOff, {xScale=.001, yScale=.001, alpha=0, time=300, transition=easing.outExpo})
            transition.to(grpConfig, {xScale=.001, yScale=.001, alpha=0, time=300, transition=easing.outExpo})
            transition.to(rctBg, {alpha=1, time=200})

            Jukebox:dispatchEvent({name="playSound", id="button"})

            globals_btnBackRelease = btnBackRelease
        end
        return true
    end
    btnPlay = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 58,
        overFrame = 59,
        onEvent = btnPlayEvent
    }
    btnPlay.anchorX, btnPlay.anchorY = .5, .5
    btnPlay.x, btnPlay.y = 0, 0
    btnPlay:scale(.001, .001)
    transition.to(btnPlay, {xScale=1, yScale=1, delay=0, time=600, transition=easing.outElastic})
    grpMenu:insert(btnPlay)



    btnBack = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 43,
        overFrame = 44,
        onEvent = btnBackRelease
    }
    grpHud:insert(btnBack)
    btnBack.anchorX, btnBack.anchorY = .5, .5
    btnBack.x, btnBack.y = Constants.LEFT + btnBack.width * .5, Constants.BOTTOM - btnBack.height * .5
    btnBack.alpha = 0
    btnBack.isActive = false



    btnGameNetwork = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 49,
        overFrame = 50,
        onEvent = _btnGameNetworkEvent
    }
    grpHud:insert(btnGameNetwork)
    btnGameNetwork.anchorX, btnGameNetwork.anchorY = .5, .5
    btnGameNetwork.x, btnGameNetwork.y = Constants.LEFT + btnBack.width * .5, Constants.TOP + btnBack.height * .5
    btnGameNetwork.alpha = 0



    grpMenu.anchorX, grpMenu.anchorY = .5, .5
    grpMenu.x, grpMenu.y = display.contentCenterX, display.contentCenterY + 125



    globals_btnBackRelease = nil
    Trt.timeScaleAll(1)
end

function objScene:getGameModeCurrent()
    return gamemode
end

function objScene:show(event)
    local grpView = self.view
    local phase = event.phase


    if phase == "will" then

        Composer.stage.alpha = 1

    elseif phase == "did" then

        grpView.isVisible = true
        
        Jukebox:dispatchEvent({name="playMusic", id=1, status=0})
        Controller:setStatus(0, true)

        if grpView.params then
            if grpView.params.sceneOverlay then
                Composer.showOverlay(grpView.params.sceneOverlay, {isModal = true, params=grpView.params})
            elseif grpView.params.reloadMode then
                btnPlayChooseEvent({phase="ended", target={mode=grpView.params.reloadMode}, isInit=false})
            end
        end

    end
end


objScene:addEventListener("create", objScene)
objScene:addEventListener("show", objScene)
objScene:addEventListener("hide", objScene)
objScene:addEventListener("destroy", objScene)


return objScene