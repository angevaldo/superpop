local Composer = require "composer"
local objScene = Composer.newScene()


local Widget = require "widget"


local Trt = require "lib.Trt"
local Controller = require "classes.superpop.business.Controller"
local Util = require "classes.superpop.business.Util"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"


local view


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local _ISBACKING = false


local btnBackRelease = function(event)
    if not _ISBACKING and "ended" == event.phase then

        _ISBACKING = true

        local grpMenu = view[2]
        transition.to(grpMenu, {alpha=0, time=100, onComplete=function()
            local tblTxtOptions = {
                parent = view,
                text = "4",
                font = Constants.TBL_STYLE.FAMILY,
                fontSize = 200,
                align = "center"
            }
            local txtCountDown = display.newText(tblTxtOptions)
            txtCountDown:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
            txtCountDown.anchorX, txtCountDown.anchorY = .5, .5
            txtCountDown.alpha = 0

            local doCount = function() end
            doCount = function()
                local count = tonumber(txtCountDown.text)
                count = count - 1

                txtCountDown.text = count
                txtCountDown.anchorX, txtCountDown.anchorY = .5, .5
                txtCountDown.x, txtCountDown.y, txtCountDown.alpha = display.contentCenterX, display.contentCenterY, 0
                txtCountDown.xScale, txtCountDown.yScale = 1, 1

                Jukebox:dispatchEvent({name="playSound", id="countdown"})
                transition.to(txtCountDown, {alpha=1, xScale=.5, yScale=.5, delay=100, time=600, transition=easing.outBack, onComplete=function()
                    if count == 1 then
                        transition.to(txtCountDown, {alpha=0, xScale=.2, yScale=.2, time=150, onComplete=function()
                            if view and view.remove then
                                view:remove(txtCountDown)
                                Controller:hideOverlay(0)
                            end
                        end})
                        Controller:setStatus(1)
                    else
                        doCount()
                    end
                end})
            end
            transition.to(grpMenu, {time=200, onComplete=doCount})

        end})

        Util:hideStatusbar()
    end
    return true
end


function objScene:create()
    local grpView = self.view


    local rctOverlay = display.newRect(grpView, -10, -10, 350, 500)
    rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
    rctOverlay:setFillColor(0, .8)


    local grpMenu = display.newGroup()
    grpView:insert(grpMenu)


    local btnSoundOn
    local btnSoundOff
    local function btnSoundEvent( event )
        if "ended" == event.phase then
            local isSoundActive = not globals_persistence:get("isSoundActive")
            globals_persistence:set("isSoundActive", isSoundActive)
            Jukebox:activateSounds(isSoundActive)

            btnSoundOn.isVisible = isSoundActive
            btnSoundOff.isVisible = not isSoundActive

            Jukebox:dispatchEvent({name="playSound", id="button"})
        end
        return false
    end
    btnSoundOn = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 47,
        overFrame = 48,
        onEvent = btnSoundEvent
    }
    btnSoundOn.x, btnSoundOn.y = Constants.RIGHT - btnSoundOn.width * .5, Constants.BOTTOM - btnSoundOn.height * .5
    btnSoundOn:scale(.001, .001)
    btnSoundOn.isVisible = globals_persistence:get("isSoundActive")
    grpMenu:insert(btnSoundOn)
    btnSoundOff = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 48,
        overFrame = 47,
        onEvent = btnSoundEvent
    }
    btnSoundOff.x, btnSoundOff.y = Constants.RIGHT - btnSoundOff.width * .5, Constants.BOTTOM - btnSoundOff.height * .5
    btnSoundOff:scale(.001, .001)
    btnSoundOff.isVisible = not globals_persistence:get("isSoundActive")
    grpMenu:insert(btnSoundOff)


    globals_btnBackRelease = btnBackRelease
    local btnPlay = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 58,
        overFrame = 59,
        onEvent = globals_btnBackRelease
    }
    btnPlay.x, btnPlay.y = display.contentCenterX, display.contentCenterY
    btnPlay:scale(.001, .001)
    grpMenu:insert(btnPlay)


    local btnHomeEvent = function(event)
        if "ended" == event.phase then
            grpView.isHome = true

            Jukebox:dispatchEvent({name="playMusic", id=1, status=0})
            transition.to(grpView, {time=1, onComplete=function()
                Controller:goNextSceneVerifyingAdsRate({scene="classes.superpop.controller.scenes.Frontend", gameMode="Timer"})
            end})

            --Composer.hideOverlay(false, "fade", 0)
        end
    end
    local btnHome = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 68,
        overFrame = 69,
        onEvent = btnHomeEvent
    }
    btnHome.x, btnHome.y = Constants.LEFT + btnHome.width * .5, Constants.BOTTOM - btnHome.height * .5
    btnHome:scale(.001, .001)
    grpMenu:insert(btnHome)


    timer.performWithDelay(1, function()
        transition.to(btnHome, {xScale=1, yScale=1, delay=200, time=600, transition=easing.outElastic})
        transition.to(btnSoundOn, {xScale=1, yScale=1, delay=400, time=600, transition=easing.outElastic})
        transition.to(btnSoundOff, {xScale=1, yScale=1, delay=400, time=600, transition=easing.outElastic})
        transition.to(btnPlay, {xScale=1, yScale=1, delay=0, time=600, transition=easing.outElastic})
    end, 1)


    view = grpView
end


function objScene:show(event)
    local grpView = self.view
    local phase = event.phase
    local parent = event.parent

    if phase == "will" then

        Controller:setStatus(2, true)
        globals_btnBackRelease = btnBackRelease

        if parent and parent.getGameModeCurrent and parent:getGameModeCurrent().pause then
            parent:getGameModeCurrent():pause(true)
        end

        Jukebox:dispatchEvent({name="stopMusic"})

    end
end


function objScene:hide(event)
    local grpView = self.view
    local phase = event.phase
    local parent = event.parent

    if phase == "did" and not grpView.isHome then

        if parent and parent.getGameModeCurrent and parent:getGameModeCurrent().pause then
            parent:getGameModeCurrent():pause(false)
        end

        Jukebox:dispatchEvent({name="playMusic", id=1, status=1})

    end
end


objScene:addEventListener("create", objScene)
objScene:addEventListener("show", objScene)
objScene:addEventListener("hide", objScene)


return objScene