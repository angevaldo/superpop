local Composer = require "composer"
local GameNetwork = require "gameNetwork"
local Widget = require "widget"
local Ads = require "plugin.applovin"


local Util = require "classes.superpop.business.Util"
local Controller = require "classes.superpop.business.Controller"
local Constants = require "classes.superpop.business.Constants"
local Jukebox = require "classes.superpop.business.Jukebox"
local AdsGame = require "classes.superpop.business.AdsGame"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local Continue = {}


function Continue:new(params)


    -- TESTING IF AD WAS LOADED
    if not Ads.isLoaded(true) then
        Ads.load(true)
        return nil
    end


    local grpView = params.grpView


    local continue = display.newGroup()
    grpView:insert(continue)


    local _destroySelf = function()
        local scnCurrent = Composer.getScene(Composer.getSceneName("current"))
        if scnCurrent and scnCurrent.getGameModeCurrent then
            local gameMode = scnCurrent:getGameModeCurrent()
            if gameMode and gameMode.doGameOver then
                gameMode:doGameOver()
            end
        end
        transition.to(continue, {time=100, onComplete=function()
            if grpView and grpView.remove then
                grpView:remove(continue)
            end
            continue = nil
        end})
    end


    globals_adCallbackListener = function(params)
        phase = params.phase
        if phase == "hidden" then
            local scnCurrent = Composer.getScene(Composer.getSceneName("current"))
            if scnCurrent and scnCurrent.getGameModeCurrent then
                local gameMode = scnCurrent:getGameModeCurrent()
                if gameMode and gameMode.doContinue then
                    gameMode:doContinue()
                else
                    _destroySelf()
                end
            else
                _destroySelf()
            end
        elseif phase == "bug" then
            _destroySelf()
        end
        if phase == "hidden" or phase == "bug" then
            globals_adCallbackListener = function() end
        end
    end


    local btnBackRelease = function(event)
        if event == nil or "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})

            if grpView and grpView.remove then
                grpView:remove(continue)
            end
            continue = nil
            globals_bntBackRelease = nil

            local scnCurrent = Composer.getScene(Composer.getSceneName("current"))
            local gameMode = scnCurrent:getGameModeCurrent()
            gameMode:doGameOver()
        end
        return true
    end
    globals_bntBackRelease = btnBackRelease


    local _onTouchOverlay = function(event)
        return true
    end
    local rctOverlay = display.newRect(continue, -10, -10, 350, 500)
    rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
    rctOverlay:setFillColor(0, .8)
    rctOverlay.touch = _onTouchOverlay
    rctOverlay:addEventListener("touch", rctOverlay)
    rctOverlay.alpha = .01


    local sptRight = display.newSprite(_SHT_UTIL, { {name="standard", frames={88} } })
    continue:insert(sptRight)
    sptRight.x, sptRight.y = display.contentCenterX, display.contentCenterY - 85
    sptRight:scale(.001, .001)

    local sptTv = display.newSprite(_SHT_UTIL, { {name="standard", frames={254} } })
    continue:insert(sptTv)
    sptTv.x, sptTv.y = display.contentCenterX - 75, display.contentCenterY - 95
    sptTv:scale(.001, .001)

    local sptAd = display.newSprite(_SHT_UTIL, { {name="standard", frames={256} } })
    continue:insert(sptAd)
    sptAd.x, sptAd.y = sptTv.x, sptTv.y
    sptAd:scale(.001, .001)

    local sptContinue = display.newSprite(_SHT_UTIL, { {name="standard", frames={255} } })
    continue:insert(sptContinue)
    sptContinue.x, sptContinue.y = display.contentCenterX + 75, display.contentCenterY - 90
    sptContinue:scale(.001, .001)


    local tblTxtOptions = {
        font = Constants.TBL_STYLE.FAMILY,
        align = "center"
    }

    tblTxtOptions.text = Constants.STR_MESSAGE_ASK_WATCH_AD_TO_CONTINUE
    tblTxtOptions.fontSize = 14
    local txtMsg = display.newText(tblTxtOptions)
    continue:insert(txtMsg)
    txtMsg:setFillColor(1)
    txtMsg.anchorX, txtMsg.anchorY = .5, .5
    txtMsg.alpha = 0
    txtMsg.x, txtMsg.y = display.contentCenterX, display.contentCenterY - 25


    local function bntYesRelease(event)
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})

            globals_bntBackRelease = nil

            if not AdsGame:showContinue() then
                _destroySelf()
            end
        end

        return true
    end
    local bntYes = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 60,
        overFrame = 61,
        onRelease = bntYesRelease
    }
    continue:insert(bntYes)
    bntYes.anchorX, bntYes.anchorY = .5, .5
    bntYes.x, bntYes.y = display.contentCenterX - 50, display.contentCenterY + 40
    bntYes:scale(.001, .001)


    local bntNo = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 76,
        overFrame = 77,
        onEvent = globals_bntBackRelease
    }
    continue:insert(bntNo)
    bntNo.anchorX, bntNo.anchorY = .5, .5
    bntNo.x, bntNo.y = display.contentCenterX + 50, display.contentCenterY + 40
    bntNo:scale(.001, .001)


    timer.performWithDelay(1, function()
        transition.to(rctOverlay, {alpha=1, time=300})
        transition.to(sptRight, {xScale=1, yScale=1, delay=0, time=600, transition=easing.outElastic})
        transition.to(sptTv, {xScale=1, yScale=1, delay=0, time=600, transition=easing.outElastic})
        transition.to(sptAd, {xScale=1, yScale=1, delay=0, time=600, transition=easing.outElastic})
        transition.blink(sptAd, {time=1000, transition=easing.inExpo})
        transition.to(sptContinue, {xScale=1, yScale=1, delay=0, time=600, transition=easing.outElastic})
        transition.to(sptContinue, {rotation=-150000, time=600000})
        transition.to(txtMsg, {alpha=1, time=600})
        transition.to(bntYes, {xScale=1, yScale=1, delay=300, time=600, transition=easing.outElastic})
        transition.to(bntNo, {xScale=1, yScale=1, delay=500, time=600, transition=easing.outElastic})    
    end,1)


    Jukebox:dispatchEvent({name="playMusic", id=1, status=0})


    return continue
end


return Continue