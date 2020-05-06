local Composer = require "composer"
local objScene = Composer.newScene()


local Widget = require "widget"


local Constants = require "classes.superpop.business.Constants"
local Controller = require "classes.superpop.business.Controller"
local Util = require "classes.superpop.business.Util"
local Jukebox = require "classes.superpop.business.Jukebox"
local Banner = require "classes.superpop.controller.animations.Banner"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local random = math.random
local round = math.round
local floor = math.floor


local _NUM_COINS_COLLECTED_TO_BONUS_THEME = Constants.NUM_COINS_COLLECTED_TO_BONUS_THEME
local _NUM_FRAMES_SPT_COINS = 50


local _txtCoins
local _txtCoinsCollected
local _sptCoin
local _btnToGo
local _sptCoinToGo
local _sptBarToGo
local _btnToGoDoAnime = function() end


function objScene:updateCoins(params)
    if _txtCoins and _txtCoins.width then

        local numCoinsCollected = globals_persistence:get("nCoins")

        _txtCoins.text = Util:formatNumber(numCoinsCollected)
        _txtCoins.x = _sptCoin.x - _sptCoin.width * .5 - _txtCoins.width * .5

        local numCoinsCollectedInit = (params.numCoinsCollected > 0 and numCoinsCollected < _NUM_COINS_COLLECTED_TO_BONUS_THEME) and params.numCoinsCollected + 25 or 0
        local numCoinsCollectedInicial = numCoinsCollected - numCoinsCollectedInit
        local numPercToGoInicial = numCoinsCollectedInicial / _NUM_COINS_COLLECTED_TO_BONUS_THEME
        numPercToGoInicial = numPercToGoInicial > 1 and 1 or numPercToGoInicial
        local numFrameInicial = floor(_NUM_FRAMES_SPT_COINS * numPercToGoInicial)
        numFrameInicial = numFrameInicial < 1 and 1 or numFrameInicial
        numFrameInicial = numFrameInicial > _NUM_FRAMES_SPT_COINS and _NUM_FRAMES_SPT_COINS or numFrameInicial

        local numCoinsCollectedFinal = numCoinsCollected
        local numPercToGoFinal = numCoinsCollectedFinal / _NUM_COINS_COLLECTED_TO_BONUS_THEME
        numPercToGoFinal = numPercToGoFinal > 1 and 1 or numPercToGoFinal
        local numFrameFinal = floor(_NUM_FRAMES_SPT_COINS * numPercToGoFinal)
        numFrameFinal = numFrameFinal == 0 and 1 or numFrameFinal
        numFrameFinal = numFrameFinal > _NUM_FRAMES_SPT_COINS and _NUM_FRAMES_SPT_COINS or numFrameFinal

        _sptBarToGo.numFrameInicial = numFrameInicial
        _sptBarToGo.numFrameFinal = numFrameFinal

        if _sptBarToGo and _sptBarToGo.play then
            if _sptBarToGo.frame < _sptBarToGo.numFrameInicial or _sptBarToGo.frame < _sptBarToGo.numFrameFinal then
                _sptBarToGo:play()
            elseif params.numCoinsCollected > 0 and globals_persistence:get("nCoins") <= _NUM_COINS_COLLECTED_TO_BONUS_THEME then
                if not params.isInit then
                    Jukebox:dispatchEvent({name="playSound", id="coinLow"})
                    _txtCoinsCollected.text = numCoinsCollected
                end
            end
        end

    end
end

local btnBackRelease = function(event)
    if event == nil or "ended" == event.phase then
        Jukebox:dispatchEvent({name="playSound", id="button"})
        Controller:goNextSceneVerifyingAdsRate({scene="classes.superpop.controller.scenes.Frontend", gameMode="Splash", view=objScene.view})
    end
    return true
end

function objScene:create(event)
    local grpView = self.view


    local params = event.params


    local rctOverlay = display.newRect(grpView, -10, -10, 350, 500)
    rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
    rctOverlay:setFillColor(0, .7)
    rctOverlay.alpha = 0
    transition.to(rctOverlay, {alpha=1, delay=0, time=500})


    local isScoreHigh, isScoreHighToday = Controller:updateScore({nScore=params.numScore, gameMode="Splash"})
    local numScoreHigh, numScoreHighToday = globals_persistence:get("nHighScoreSplash"), globals_persistence:get("nHighScoreSplashToday")


    local _btnGameNetworkEvent = function(event)
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})
            local GameNetwork = require "gameNetwork"
            GameNetwork.show("leaderboards")
        end
    end
    local Ranking = require "classes.superpop.controller.animations.Ranking"
    local grpRank = Ranking:new({isHorizontal=true, gameMode="Splash"})
    grpRank.x, grpRank.y, grpRank.alpha = Constants.LEFT, Constants.TOP - 50, 0
    grpRank.touch = function(self, event) _btnGameNetworkEvent(event) end
    grpRank:addEventListener("touch", grpRank)
    grpView:insert(grpRank)
    transition.to(grpRank, {alpha=1, delay=800, time=500, y=Constants.TOP, transition=easing.outBack})


    _sptCoin = display.newSprite(_SHT_UTIL, { {name="s", start=92, count=1} })
    _sptCoin.x, _sptCoin.y = Constants.RIGHT - _sptCoin.width * .5, Constants.TOP + _sptCoin.height * .5
    _sptCoin.alpha = 0
    transition.to(_sptCoin, {alpha=1, delay=800, time=600})
    grpView:insert(_sptCoin)


    _txtCoins = display.newText(grpView, "", 0, 0, Constants.TBL_STYLE.FAMILY, 28)
    _txtCoins:setFillColor(Constants.TBL_STYLE.COLOR_COINS[1], Constants.TBL_STYLE.COLOR_COINS[2], Constants.TBL_STYLE.COLOR_COINS[3], Constants.TBL_STYLE.COLOR_COINS[4])
    _txtCoins.anchorX, _txtCoins.anchorY = .5, .5
    _txtCoins.alpha = 0
    _txtCoins.x, _txtCoins.y = _sptCoin.x - _sptCoin.width * .5 - _txtCoins.width * .5, _sptCoin.y
    transition.to(_txtCoins, {alpha=1, delay=800, time=600})


    local txtScoreHigh = display.newText(grpView, Util:formatNumber(numScoreHigh), 0, 0, Constants.TBL_STYLE.FAMILY, 16)
    txtScoreHigh:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
    txtScoreHigh.anchorX, txtScoreHigh.anchorY = .5, .5
    txtScoreHigh.alpha = 0
    txtScoreHigh.x, txtScoreHigh.y = display.contentCenterX + 35, display.contentCenterY - 10
    transition.to(txtScoreHigh, {alpha=1, delay=800, time=600})

    local sptScoreHigh = display.newSprite(_SHT_UTIL, { {name="standard", frames={90} } })
    sptScoreHigh.anchorX, sptScoreHigh.anchorY = .5, 1
    sptScoreHigh.x, sptScoreHigh.y = txtScoreHigh.x, txtScoreHigh.y - txtScoreHigh.height * .5
    sptScoreHigh.alpha = 0
    transition.to(sptScoreHigh, {alpha=1, delay=800, time=600})
    grpView:insert(sptScoreHigh)

    local txtScoreToday = display.newText(grpView, Util:formatNumber(numScoreHighToday), 0, 0, Constants.TBL_STYLE.FAMILY, 16)
    txtScoreToday:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
    txtScoreToday.anchorX, txtScoreToday.anchorY = .5, .5
    txtScoreToday.alpha = 0
    txtScoreToday.x, txtScoreToday.y = display.contentCenterX - 35, txtScoreHigh.y
    transition.to(txtScoreToday, {alpha=1, delay=1000, time=600})

    local sptScoreToday = display.newSprite(_SHT_UTIL, { {name="standard", frames={91} } })
    sptScoreToday.anchorX, sptScoreToday.anchorY = .5, 1
    sptScoreToday.x, sptScoreToday.y = txtScoreToday.x, txtScoreToday.y - txtScoreToday.height * .5
    sptScoreToday.alpha = 0
    transition.to(sptScoreToday, {alpha=1, delay=1000, time=600})
    grpView:insert(sptScoreToday)
    
    local grpScore = display.newGroup()
    grpView:insert(grpScore)

    local strScore = Util:formatNumber(params.numScore)

    local txtScoreS1 = display.newText(grpScore, strScore, 0, 0, Constants.TBL_STYLE.FAMILY, 82)
    txtScoreS1:setFillColor(0, .65)
    txtScoreS1.anchorX, txtScoreS1.anchorY = .5, .5
    txtScoreS1.x, txtScoreS1.y = 2, 2

    local txtScoreS2 = display.newText(grpScore, strScore, 0, 0, Constants.TBL_STYLE.FAMILY, 82)
    txtScoreS2:setFillColor(0, .2)
    txtScoreS2.anchorX, txtScoreS2.anchorY = .5, .5
    txtScoreS2.x, txtScoreS2.y = -1, -1

    local txtScore = display.newText(grpScore, strScore, 0, 0, Constants.TBL_STYLE.FAMILY, 82)
    txtScore:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
    txtScore.anchorX, txtScore.anchorY = .5, .5
    txtScore.x, txtScore.y = 0, 0

    grpScore.anchorChildren = true
    grpScore.x, grpScore.y = display.contentCenterX, display.contentCenterY - 80
    grpScore.xScale, grpScore.yScale = .001, .001
    transition.to(grpScore, {xScale=1, yScale=1, delay=400, time=600, transition=easing.outElastic})
    if isScoreHigh or isScoreHighToday then
        transition.to(grpScore, {delay=300, time=100, onComplete=function()
            Jukebox:dispatchEvent({name="playSound", id="record"})
        end})
    end


    local grpMenuToGo = display.newGroup()
    grpView:insert(grpMenuToGo)

    local grpCoinsCollected = display.newGroup()
    grpMenuToGo:insert(grpCoinsCollected)

    _txtCoinsCollected = display.newText(grpCoinsCollected, globals_persistence:get("nCoins") - params.numCoinsCollected, 0, 0, Constants.TBL_STYLE.FAMILY, 11)
    _txtCoinsCollected:setFillColor(Constants.TBL_STYLE.COLOR_COINS[1], Constants.TBL_STYLE.COLOR_COINS[2], Constants.TBL_STYLE.COLOR_COINS[3], Constants.TBL_STYLE.COLOR_COINS[4])
    _txtCoinsCollected.anchorX, _txtCoinsCollected.anchorY = 1, .5
    _txtCoinsCollected.x, _txtCoinsCollected.y = 1, 0

    local txtCoinsToCollected = display.newText(grpCoinsCollected, " / ".._NUM_COINS_COLLECTED_TO_BONUS_THEME, 0, 0, Constants.TBL_STYLE.FAMILY, 11)
    txtCoinsToCollected:setFillColor(Constants.TBL_STYLE.COLOR_COINS[1], Constants.TBL_STYLE.COLOR_COINS[2], Constants.TBL_STYLE.COLOR_COINS[3], Constants.TBL_STYLE.COLOR_COINS[4])
    txtCoinsToCollected.anchorX, txtCoinsToCollected.anchorY = 0, .5
    txtCoinsToCollected.x, txtCoinsToCollected.y = 0, 0

    local sptCoinToCollected = display.newSprite(_SHT_UTIL, { {name="s", start=92, count=1} })
    sptCoinToCollected:scale(.4, .4)
    sptCoinToCollected.anchorX, sptCoinToCollected.anchorY = 0, .5
    sptCoinToCollected.x, sptCoinToCollected.y = txtCoinsToCollected.x + txtCoinsToCollected.width + 1, txtCoinsToCollected.y
    grpCoinsCollected:insert(sptCoinToCollected)

    grpCoinsCollected.anchorChildren = true
    grpCoinsCollected.anchorX, grpCoinsCollected.anchorY = .5, .5
    grpCoinsCollected.x, grpCoinsCollected.y = 0, 18

    local grpToGo

    local _onSpriteCoins = function(self, event)
        local numPercCollected = self.frame / self.numFrameFinal
        local numPerc = self.frame / self.numFrames
        _sptCoinToGo.x = self.width * numPerc - self.width * .5 - 3
        _sptCoinToGo.isVisible = true

        local numCoinsCollectedFinal = globals_persistence:get("nCoins")

        local numCoinsCollectedCurrent = numCoinsCollectedFinal > _NUM_COINS_COLLECTED_TO_BONUS_THEME and _NUM_COINS_COLLECTED_TO_BONUS_THEME or numCoinsCollectedFinal
        _txtCoinsCollected.text = floor(numCoinsCollectedCurrent * numPercCollected)

        if self.frame % 2 == 0 and grpMenuToGo.alpha == 1 then
            Jukebox:dispatchEvent({name="playSound", id="coinLow"})
        end

        if event.phase == "ended" or self.frame >= self.numFrameFinal or (event.phase ~= "began" and self.frame == self.numFrameInicial) then
            self:pause()
            if self.frame == self.numFrames then
                _sptCoinToGo.isVisible = false
                grpToGo.isVisible = true
                    Jukebox:dispatchEvent({name="playSound", id="collect"})
                transition.to(grpToGo, {time=500, xScale=1, yScale=1, transition=easing.outElastic, onComplete=function()
                    _btnToGoDoAnime()
                end})
            end
            if self.frame ~= self.numFrameInicial then
                _txtCoinsCollected.text = numCoinsCollectedCurrent
            end
        end
    end
    _sptBarToGo = display.newSprite(_SHT_UTIL, { {name="s", start=146, count=_NUM_FRAMES_SPT_COINS, time=1500, loopCount=0} })
    _sptBarToGo.sprite = _onSpriteCoins
    _sptBarToGo:addEventListener("sprite", _sptBarToGo)
    _sptBarToGo.anchorX, _sptBarToGo.anchorY = .5, .5
    _sptBarToGo.x, _sptBarToGo.y = 0, 0
    grpMenuToGo:insert(_sptBarToGo)

    _sptCoinToGo = display.newSprite(_SHT_UTIL, { {name="s", start=92, count=1} })
    _sptCoinToGo.x, _sptCoinToGo.y = _sptBarToGo.width * (_sptBarToGo.frame / _sptBarToGo.numFrames) - _sptBarToGo.width * .5 - 3, -1
    _sptCoinToGo:scale(.55, .55)
    grpMenuToGo:insert(_sptCoinToGo)

    grpToGo = display.newGroup()
    grpView:insert(grpToGo)
    _btnToGoDoAnime = function()
        if grpToGo and globals_persistence:get("nCoins") >= _NUM_COINS_COLLECTED_TO_BONUS_THEME then
            if grpToGo._TRT_CANCEL ~= nil then
                transition.cancel(grpToGo._TRT_CANCEL)
                grpToGo._TRT_CANCEL = nil
            end
            grpToGo._TRT_CANCEL = transition.to(grpToGo, {xScale=.85, yScale=.85, time=350, onComplete=function()
                grpToGo._TRT_CANCEL = transition.to(grpToGo, {xScale=1, yScale=1, time=350, onComplete=function()
                    _btnToGoDoAnime()
                end})
            end})
        end
    end
    local function _btnToGoEvent(event)
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})

            if grpToGo._TRT_CANCEL ~= nil then
                transition.cancel(grpToGo._TRT_CANCEL)
                grpToGo._TRT_CANCEL = nil
            end
            grpToGo.isVisible = false
            grpToGo:scale(.001, .001)

            globals_persistence:addCoins(-_NUM_COINS_COLLECTED_TO_BONUS_THEME)
            params.numCoinsCollected = -_NUM_COINS_COLLECTED_TO_BONUS_THEME

            _sptBarToGo:play()

            self:updateCoins(params)

            local Bonus = require "classes.superpop.controller.animations.Bonus"
            local bonus = Bonus:new()
        end
    end
    _btnToGo = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 45,
        overFrame = 46,
        onEvent = _btnToGoEvent
    }
    _btnToGo.anchorX, _btnToGo.anchorY = .5, .5
    _btnToGo.x, _btnToGo.y = 0, 0
    grpToGo:insert(_btnToGo)

    grpToGo.anchorX, grpToGo.anchorY = .5, .5
    grpToGo.x, grpToGo.y = display.contentCenterX + 48, display.contentCenterY + 30
    grpToGo.isVisible = false
    grpToGo:scale(.001, .001)

    grpMenuToGo.anchorX, grpMenuToGo.anchorY = .5, .5
    grpMenuToGo.x, grpMenuToGo.y = display.contentCenterX, grpToGo.y + 2
    grpMenuToGo.alpha = 0
    transition.to(grpMenuToGo, {alpha=1, delay=1500, time=100, onComplete=function()
        if self and self.updateCoins then
            self:updateCoins(params)
        end
    end})
    self:updateCoins({isInit=true, numCoinsCollected=params.numCoinsCollected})


    local grpMenu = display.newGroup()
    grpView:insert(grpMenu)


    local btnHome = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 68,
        overFrame = 69,
        onEvent = btnBackRelease
    }
    btnHome.x, btnHome.y = -75, 0
    btnHome:scale(.001, .001)
    transition.to(btnHome, {xScale=1, yScale=1, delay=700, time=600, transition=easing.outElastic})
    grpMenu:insert(btnHome)


    local btnReloadEvent = function(event)
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})
            Controller:goNextSceneVerifyingAdsRate({scene="classes.superpop.controller.scenes.Frontend", gameMode="Splash", reloadMode="Splash", view=objScene.view})
        end
    end
    local btnReload = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 60,
        overFrame = 61,
        onEvent = btnReloadEvent
    }
    btnReload.x, btnReload.y = 0, 0
    btnReload:scale(.001, .001)
    transition.to(btnReload, {xScale=1, yScale=1, delay=850, time=600, transition=easing.outElastic})
    grpMenu:insert(btnReload)


    local _btnDoShareEvent = function(event)
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})

            local serviceName = event.target.id
            local URL_SERVICE = serviceName == "facebook" and Constants.STR_URL_FACEBOOK_PAGE or Constants.STR_URL_TWITTER_ACCOUNT
            local isAvailable = system.getInfo("platformName") == "Android" and true or native.canShowPopup("social", serviceName)

            if isAvailable then
                grpRank.isVisible = false
                grpMenu.isVisible = false
                grpMenuToGo.isVisible = false
                sptScoreToday.isVisible = false
                sptScoreHigh.isVisible = false
                txtScoreToday.isVisible = false
                txtScoreHigh.isVisible = false
                _sptCoin.isVisible = false
                _txtCoins.isVisible = false

                local grpScreen = display.newGroup()
                grpView.parent:insert(grpScreen)
                grpScreen:toBack()

                local sptBounds = display.newRect(grpScreen, 0,0, 320, 320)
                sptBounds:scale(.66, .66)
                sptBounds.x, sptBounds.y = grpScore.x, grpScore.y

                local imgBG = display.newImageRect(grpScreen, "images/share.jpg", 320, 320)

                local screenCap = display.captureBounds(sptBounds.contentBounds)
                screenCap.x, screenCap.y = 0, 17
                grpScreen:insert(screenCap)
                grpScreen:scale(.6, .6)

                sptBounds:removeSelf()
                sptBounds = nil

                local imgLogo = display.newSprite(_SHT_UTIL, { {name="s", start=228, count=1} })
                imgLogo.anchorX, imgLogo.anchorY = .5, 0
                imgLogo.x, imgLogo.y = 0, -155
                imgLogo:scale(.8, .8)
                grpScreen:insert(imgLogo)

                local imgFG = display.newSprite(_SHT_UTIL, { {name="s", start=70, count=1} })
                imgFG.anchorX, imgFG.anchorY = 1, 1
                imgFG.x, imgFG.y = 156, 156
                grpScreen:insert(imgFG)

                display.save(grpScreen, {filename="share.jpg", isFullResolution=true, baseDir=system.CachesDirectory, backgroundColor={1}})

                native.showPopup("social", {
                    service = serviceName, 
                    message = strScore .. " POINTS on Splash mode! " .. Constants.STR_SOCIAL_SHARE_MESSAGE,
                    image = { {filename="share.jpg", baseDir=system.CachesDirectory} },
                    url = { URL_SERVICE }
                })

                grpView.parent:remove(grpScreen)
                grpScreen = nil

                grpRank.isVisible = true
                grpMenu.isVisible = true
                grpMenuToGo.isVisible = true
                sptScoreToday.isVisible = true
                sptScoreHigh.isVisible = true
                txtScoreToday.isVisible = true
                txtScoreHigh.isVisible = true
                _sptCoin.isVisible = true
                _txtCoins.isVisible = true
            else
                local Toast = require('plugin.toast')
                Toast.show("Not available", {duration="long"})
            end

        end
    end

    local btnFacebook = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 84,
        overFrame = 85,
        onEvent = _btnDoShareEvent
    }
    btnFacebook.anchorX, btnFacebook.anchorY = .5, .5
    btnFacebook.x, btnFacebook.y, btnFacebook.alpha = 75, 0, 0
    btnFacebook.id = "facebook"
    btnFacebook:scale(.001, .001)
    grpMenu:insert(btnFacebook)

    local btnTwitter = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 86,
        overFrame = 87,
        onEvent = _btnDoShareEvent
    }
    btnTwitter.anchorX, btnTwitter.anchorY = .5, .5
    btnTwitter.x, btnTwitter.y, btnTwitter.alpha = 75, 0, 0
    btnTwitter.id = "twitter"
    btnTwitter:scale(.001, .001)
    grpMenu:insert(btnTwitter)

    local _btnShareEvent = function(event)
        if "began" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})
            transition.to(event.target, {xScale=.001, yScale=.001, alpha=0, time=600, transition=easing.outElastic})
            transition.to(btnFacebook, {xScale=1, yScale=1, y=-28, alpha=1, time=600, transition=easing.outElastic})
            transition.to(btnTwitter, {xScale=1, yScale=1, y=28, alpha=1, time=600, transition=easing.outElastic})
        end
    end
    local numFrameShare = system.getInfo("platformName") == "Android" and 83 or 82
    local btnShare = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = numFrameShare,
        overFrame = numFrameShare,
        onEvent = system.getInfo("platformName") == "Android" and _btnDoShareEvent or _btnShareEvent
    }
    btnShare.anchorX, btnShare.anchorY = .5, .5
    btnShare.x, btnShare.y = 75, 0
    btnShare:scale(.001, .001)
    transition.to(btnShare, {xScale=1, yScale=1, delay=1000, time=600, transition=easing.outElastic})
    grpMenu:insert(btnShare)


    grpMenu.anchorX, grpMenu.anchorY = .5, .5
    grpMenu.x, grpMenu.y = display.contentCenterX, display.contentCenterY + 125

    
    local grpBanner = display.newGroup()
    grpView:insert(grpBanner)
    Banner:Create({grpView=grpBanner})


    if isScoreHigh or isScoreHighToday then
        local Confetti = require "classes.superpop.controller.animations.Confetti"
        local confetti = Confetti:new({grpView=grpView, isGold=isScoreHigh})
    end


    Util:hideStatusbar()
end


function objScene:show(event)
    local grpView = self.view
    local phase = event.phase
    local parent = event.parent

    if phase == "will" then

        globals_btnBackRelease = btnBackRelease

    elseif phase == "did" then

        Controller:setStatus(3, true)

        Jukebox:dispatchEvent({name="playMusic", id=1, status=0})

    end
end


function objScene:hide(event)
    local grpView = self.view
    local phase = event.phase
    local parent = event.parent

    if phase == "did" then


    end
end


objScene:addEventListener("create", objScene)
objScene:addEventListener("show", objScene)
objScene:addEventListener("hide", objScene)


return objScene