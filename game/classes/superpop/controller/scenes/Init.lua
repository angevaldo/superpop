local Composer = require "composer"
local objScene = Composer.newScene()


local Constants = require "classes.superpop.business.Constants"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local _IS_ANIMATING = false


local _doAnime = function() end


local _doInit = function() 
    -- INIT CONTROLLER
    local Controller = require "classes.superpop.business.Controller"
    Controller:init()

    -- VERIFY IF UPDATE DATA
    globals_persistence:updateDatabase()

    -- INIT SOUNDS
    local Jukebox = require "classes.superpop.business.Jukebox"
    local isSoundActive = globals_persistence:get("isSoundActive")
    Jukebox:activateSounds(isSoundActive)
    Jukebox:activateStory(isSoundActive)
end


function objScene:create(event)
    local grpView = self.view

    local imgBkgLogo = display.newSprite(_SHT_UTIL, { {name="s", frames={1} } })
    imgBkgLogo.anchorX, imgBkgLogo.anchorY = .5, 1
    imgBkgLogo.x, imgBkgLogo.y, imgBkgLogo.alpha = display.contentCenterX, Constants.BOTTOM
    grpView:insert(imgBkgLogo)

    local sptLogo = display.newSprite(_SHT_UTIL, { {name="s", frames={199} } })
    sptLogo.anchorX, sptLogo.anchorY = .5, .5
    sptLogo.x, sptLogo.y = display.contentCenterX, display.contentCenterY
    sptLogo:scale(2, 2)
    sptLogo.alpha = 0
    grpView:insert(sptLogo)


    _doAnime = function() 
        if not _IS_ANIMATING then
            _IS_ANIMATING = true

            transition.to(imgBkgLogo, {alpha=1, time=200})
            transition.to(sptLogo, {time=100, onComplete=function()
                transition.to(sptLogo, {alpha=1, xScale=1, yScale=1, time=200, transition=easing.outExpo, onComplete=function()
                
                    -- CALL INITIALIZATION
                    _doInit()

                    transition.to(sptLogo, {time=10, onComplete=function()
                        local options = {
                            effect = "crossFade",
                            time = 200,
                        }
                        local scene = Constants.BOL_IS_TO_SHOW_INTRO_STORY and "Story" or "Frontend"
                        Composer.gotoScene("classes.superpop.controller.scenes."..scene, options)
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

        _doAnime()

    end
end


objScene:addEventListener("create", objScene)
objScene:addEventListener("show", objScene)


return objScene