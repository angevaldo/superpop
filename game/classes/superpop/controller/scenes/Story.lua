local Composer = require "composer"
local objScene = Composer.newScene()


local Controller = require "classes.superpop.business.Controller"
local Constants = require "classes.superpop.business.Constants"
local Jukebox = require "classes.superpop.business.Jukebox"


local _IS_ANIMATING = false


local _doAnime = function() end


local function btnPlayRelease(event)
    if event == nil or "ended" == event.phase then
        Jukebox:dispatchEvent({name="playSound", id="button"})
        local options = {
            effect = "crossFade",
            time = 200,
        }            
        Composer.gotoScene("classes.superpop.controller.scenes.Frontend", options)
    end
end


function objScene:create(event)
    local grpView = self.view


    local infStory = require("classes.superpop.sprites.story")
    local _SHT_STORY = graphics.newImageSheet("images/story.png", infStory:getSheet())


    -- STORY
    local grpStory = display.newGroup()
    grpView:insert(grpStory)

    local rctOverlay = display.newRect(grpStory, -10, -10, 350, 500)
    rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
    rctOverlay:setFillColor(1)

    local sptFrame2 = display.newSprite(_SHT_STORY, { {name="s", frames={2} } })
    sptFrame2.anchorX, sptFrame2.anchorY = .5, 0
    sptFrame2.xTo, sptFrame2.x, sptFrame2.y = display.contentCenterX, 500, 100
    grpStory:insert(sptFrame2)

    local sptFrame6 = display.newSprite(_SHT_STORY, { {name="s", frames={6} } })
    sptFrame6.anchorX, sptFrame6.anchorY = .5, 0
    sptFrame6.xTo, sptFrame6.x, sptFrame6.y = display.contentCenterX, 500, 130
    grpStory:insert(sptFrame6)

    local sptFrame7 = display.newSprite(_SHT_STORY, { {name="s", frames={7} } })
    sptFrame7.anchorX, sptFrame7.anchorY = .5, 0
    sptFrame7.xTo, sptFrame7.x, sptFrame7.y = display.contentCenterX, 500, 130
    grpStory:insert(sptFrame7)

    local sptFrame1 = display.newSprite(_SHT_STORY, { {name="s", frames={1} } })
    sptFrame1.anchorX, sptFrame1.anchorY = .5, 0
    sptFrame1.xTo, sptFrame1.x, sptFrame1.y = display.contentCenterX, -500, 28
    grpStory:insert(sptFrame1)

    local sptFrame3 = display.newSprite(_SHT_STORY, { {name="s", frames={3} } })
    sptFrame3.anchorX, sptFrame3.anchorY = .5, 0
    sptFrame3.xTo, sptFrame3.x, sptFrame3.y = display.contentCenterX, -500, 229
    grpStory:insert(sptFrame3)

    local sptFrame4 = display.newSprite(_SHT_STORY, { {name="s", frames={4} } })
    sptFrame4.anchorX, sptFrame4.anchorY = .5, 0
    sptFrame4.xTo, sptFrame4.x, sptFrame4.y = display.contentCenterX, 500, 303
    grpStory:insert(sptFrame4)

    local sptFrame5 = display.newSprite(_SHT_STORY, { {name="s", frames={5} } })
    sptFrame5.anchorX, sptFrame5.anchorY = .5, 0
    sptFrame5.xTo, sptFrame5.x, sptFrame5.y = display.contentCenterX, 500, 0
    grpStory:insert(sptFrame5)

    local sptFrame8 = display.newSprite(_SHT_STORY, { {name="s", frames={8} } })
    sptFrame8.anchorX, sptFrame8.anchorY = .5, 0
    sptFrame8.xTo, sptFrame8.x, sptFrame8.y = display.contentCenterX, -800, 353
    grpStory:insert(sptFrame8)

    --COMMENT ON PRODUCTION
    --Composer.gotoScene("classes.superpop.controller.scenes.Frontend", {effect="fade", time=0})

    globals_btnBackRelease = btnPlayRelease

    _doAnime = function() 
        if not _IS_ANIMATING then
            _IS_ANIMATING = true

            Jukebox:dispatchEvent({name="playStory", id="tiptoe"})

            transition.to(sptFrame5, {transition=easing.outExpo, time=600, x=sptFrame5.xTo})
            transition.to(sptFrame1, {transition=easing.outExpo, time=300, x=sptFrame1.xTo, onComplete=function()
                transition.to(rctOverlay, {time=500, onComplete=function()

                    Jukebox:dispatchEvent({name="playStory", id="draw"})
                    transition.to(sptFrame6, {transition=easing.outExpo, time=700, x=sptFrame6.xTo})
                    transition.to(sptFrame7, {transition=easing.outExpo, time=500, x=sptFrame7.xTo})
                    transition.to(sptFrame2, {transition=easing.outExpo, time=300, x=sptFrame2.xTo, onComplete=function()
                        transition.to(rctOverlay, {time=700, onComplete=function()

                            Jukebox:dispatchEvent({name="playStory", id="fillup"})
                            transition.to(sptFrame3, {transition=easing.outExpo, time=300, x=sptFrame3.xTo, onComplete=function()
                                transition.to(rctOverlay, {time=700, onComplete=function()

                                    transition.to(sptFrame4, {transition=easing.outExpo, time=200, x=sptFrame4.xTo, onComplete=function()
                                        Jukebox:dispatchEvent({name="playStory", id="throw"})
                                    end})
                                    transition.to(sptFrame8, {transition=easing.outExpo, time=500, x=sptFrame8.xTo, onComplete=function()

                                        display.setDefault("background", 1)

                                        local btnPlaySplashMode
                                        local _btnPlayAnim = function() end
                                        _btnPlayAnim = function()
                                            if btnPlaySplashMode then
                                                if btnPlaySplashMode._TRT_CANCEL ~= nil then
                                                    transition.cancel(btnPlaySplashMode._TRT_CANCEL)
                                                    btnPlaySplashMode._TRT_CANCEL = nil
                                                end
                                                btnPlaySplashMode._TRT_CANCEL = transition.to(btnPlaySplashMode, {xScale=.85, yScale=.85, time=400, onComplete=function()
                                                    btnPlaySplashMode._TRT_CANCEL = transition.to(btnPlaySplashMode, {xScale=1, yScale=1, time=400, onComplete=function()
                                                        _btnPlayAnim()
                                                    end})
                                                end})
                                            end
                                        end
                                        local infUtil = require("classes.superpop.sprites.util")
                                        local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())
                                        local Widget = require "widget"
                                        btnPlaySplashMode = Widget.newButton{
                                            sheet = _SHT_UTIL,
                                            defaultFrame = 58,
                                            overFrame = 59,
                                            onEvent = btnPlayRelease
                                        }
                                        btnPlaySplashMode.anchorX, btnPlaySplashMode.anchorY = .5, .5
                                        btnPlaySplashMode.x, btnPlaySplashMode.y = Constants.RIGHT - btnPlaySplashMode.width * .5, Constants.BOTTOM - btnPlaySplashMode.height * .5
                                        btnPlaySplashMode:scale(.001, .001)
                                        grpView:insert(btnPlaySplashMode)
                                        transition.to(btnPlaySplashMode, {xScale=1, delay=100, yScale=1, time=500, transition=easing.outElastic, onComplete=function()
                                            _btnPlayAnim()
                                        end})

                                    end})
                                end})
                            end})
                        end})
                    end})
                end})
            end})
        end
    end
end


function objScene:show(event)
    local grpView = self.view
    local phase = event.phase
    
    if phase == "did" then

        Controller:setStatus(0, true)
        
        Jukebox:dispatchEvent({name="playMusic", id=1, status=0})

        _doAnime()

    end
end


function objScene:hide(event)
    local grpView = self.view
    local phase = event.phase

    if phase == "did" then

        local Jukebox = require "classes.superpop.business.Jukebox"
        Jukebox:activateStory(false)
        Composer:removeScene("classes.superpop.controller.scenes.Story")

    end
end


objScene:addEventListener("create", objScene)
objScene:addEventListener("show", objScene)
objScene:addEventListener("hide", objScene)


return objScene