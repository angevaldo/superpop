local Composer = require "composer"


local random = math.random


local Controller = require "classes.superpop.business.Controller"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())
local _SHT_THEME_CURRENT = Controller:getSheet()
local infThemes = require("classes.superpop.sprites.themes")
local _SHT_THEMES = graphics.newImageSheet("images/themes.png", infThemes:getSheet())


local Bonus = {}


local _TBL_FRAMES_EXPLOSION = { {7, 25}, {32, 20} }
local _TBL_IAP_THEMES_FRAMES = Constants.TBL_IAP_THEMES_FRAMES


function Bonus:new(params)

    local params = params or {}
    

    local scene = Composer.getScene(Composer.getSceneName("overlay"))
    scene = scene == nil and Composer.getScene(Composer.getSceneName("current")) or scene
	local grpView = params.grpView or scene.view


    local TBL_BONUS = {}
    local NUM_THEME_ID = globals_persistence:getBonusThemeId()


	local bonus = display.newGroup()

    if grpView and grpView.insert then


    	grpView:insert(bonus)


    	local _onTouchOverlay = function(event)
    		return true
    	end
        local rctOverlay = display.newRect(bonus, -10, -10, 350, 500)
        rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
        rctOverlay:setFillColor(0, .7)--random(),random(),random())
        rctOverlay.touch = _onTouchOverlay
        rctOverlay:addEventListener("touch", rctOverlay)


        local grpMenu = display.newGroup()
        bonus:insert(grpMenu)

        local _createThemeThumb = function(params)   
            local sptTheme = display.newSprite(_SHT_THEMES, { {name="standard", frames=_TBL_IAP_THEMES_FRAMES[NUM_THEME_ID]} })
            sptTheme.anchorX, sptTheme.anchorY = .5, .5
            sptTheme.x, sptTheme.y = params.x, params.y
            sptTheme:scale(.5, .5)
            grpMenu:insert(sptTheme)
            sptTheme:toBack()

            return sptTheme
        end

        local _unlockTheme = function(sptTheme)        
            -- UNLOCK THEME
            local tblBuyed = globals_persistence:get("tThemeBuyed")
            tblBuyed["t"..string.format("%02d", NUM_THEME_ID)] = true
            globals_persistence:set("tThemeBuyed", tblBuyed)

            transition.to(sptTheme, {time=1000, onComplete=function()
                Jukebox:dispatchEvent({name="playSound", id="collect"})
                transition.to(sptTheme, {x=140, y=0, xScale=1, yScale=1, transition=easing.outElastic, time=500, onComplete=function()
                    transition.to(sptTheme, {time=300, onComplete=function()                    
                        Controller:setTheme(NUM_THEME_ID)

                        Composer.stage.alpha = 0
                        local options = {
                            effect = "fade",
                            time = 0,
                            params = {scene="classes.superpop.controller.scenes.Frontend"}
                        }
                        Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", options)
                    end})
                end})
            end})

        end

        local _onSpriteExplosion = function(self, event)
            if event.phase == "ended" then
                if self and self.isVisible then
                    self.isVisible = false
                end
                transition.to(bonus, {time=500, onComplete=function()                    
                    transition.to(bonus, {alpha=0, time=300, onComplete=function()                    
                        grpView:remove(bonus)
                        bonus = nil
                    end})
                end})
            end
        end

        local _onTouch = function(self, event)
            if event.phase == "ended" then
                self:removeEventListener("touch")
                self.alpha = .01                

                if self._CANCEL_BREATH ~= nil then
                    Trt.cancel(self._CANCEL_BREATH)
                    self._CANCEL_BREATH = nil
                end

                local e = random(2)
                local sptExplosion = display.newSprite(_SHT_THEME_CURRENT, { 
                    {name="e", start=_TBL_FRAMES_EXPLOSION[e][1], count=_TBL_FRAMES_EXPLOSION[e][2], time=500 + 100 * e, loopCount=1},
                })
                sptExplosion:setFillColor(1, 0, 0)
                sptExplosion.x, sptExplosion.y = self.x, self.y
                self.parent:insert(sptExplosion)
                if random(2) == 1 then
                    sptExplosion.xScale = -1.6
                else
                    sptExplosion.xScale = 1.6
                end
                if random(2) == 1 then
                    sptExplosion.yScale = -1.6
                else
                    sptExplosion.yScale = 1.6
                end
                sptExplosion.sprite = _onSpriteExplosion

                if NUM_THEME_ID then
                    local params = {}
                    local isUnlocked = random(2) == 1 or NUM_THEME_ID == Constants.NUM_FIRST_BONUS_THEME_ID

                    if isUnlocked then
                        params.x, params.y = self.x, self.y
                        local strId = "pop"..random(1, 5)
                        Jukebox:dispatchEvent({name="playSound", id=strId})
                    else
                        local tblIDs = {1,2,3}
                        table.remove(tblIDs, self.id)
                        local idRandom = tblIDs[random(#tblIDs)]
                        params.x, params.y = TBL_BONUS[idRandom].x, TBL_BONUS[idRandom].y
                        sptExplosion:addEventListener("sprite", sptExplosion)
                        Jukebox:dispatchEvent({name="playSound", id="negation"})
                    end

                    local sptTheme = _createThemeThumb(params)
                    if isUnlocked then
                        _unlockTheme(sptTheme)
                    end
                else
                    sptExplosion:addEventListener("sprite", sptExplosion)
                    Jukebox:dispatchEvent({name="playSound", id="negation"})
                end

                sptExplosion:play()

                local linBonus = self.linBonus
                transition.to(linBonus, {y=300, time=600, alpha=0, transition=easing.inExpo, onComplete=function(self)
                    local grp = self.parent
                    if grp and grp.remove then
                        grp:remove(self)
                        self = nil
                    end
                end})
                for i=1, 3 do
                    if self.id ~= i then
                        local sptBonus = TBL_BONUS[i]
                        sptBonus:removeEventListener("touch", sptBonus)
                        transition.to(sptBonus.parent, {alpha=0, time=200, onComplete=function()
                            sptBonus.isVisible = false
                        end})
                    end
                end
            end
        end

        local _moveBonus = function() end
        _moveBonus = function(self)
            local numTime = random(5,9) * 100
            transition.to(self, {y=self.y+2, time=numTime, onComplete=function()
                local numTime = random(5,9) * 100
                transition.to(self, {y=self.y-2, time=numTime, onComplete=function()
                    if self and self.moveBonus then
                        self:moveBonus()
                    end
                end})
            end})
        end    

        for i=1, 3 do
            local grpBonus = display.newGroup()
            grpMenu:insert(grpBonus)

            local sptBonus = display.newSprite(_SHT_UTIL, { {name="s", frames={95} }})
            sptBonus.anchorX, sptBonus.anchorY = .5, .5
            sptBonus.x, sptBonus.y = 70 * i, 0
            sptBonus.sptExplosion = sptExplosion
            sptBonus.id = i
            sptBonus.touch = _onTouch
            sptBonus.moveBonus = _moveBonus
            grpBonus:insert(sptBonus)

            sptBonus:moveBonus()

            local linBonus = display.newLine(grpBonus, sptBonus.x,35, sptBonus.x,300)
            linBonus:setStrokeColor(.5,.4,.4, .3)
            linBonus.strokeWidth = 1
            linBonus:toBack()

            sptBonus.linBonus = linBonus

            TBL_BONUS[#TBL_BONUS + 1] = sptBonus
        end

        grpMenu.anchorChildren = true
        grpMenu.anchorX, grpMenu.anchorY = .5, 0
        grpMenu.x, grpMenu.y = display.contentCenterX, 500


        transition.to(grpMenu, {time=500, onComplete=function()

            for i=1, 3 do
                transition.to(grpMenu, {delay=200, time=100 * i, onComplete=function()
                    local strID = "move"..random(7)
                    Jukebox:dispatchEvent({name="playSound", id=strID})
                end})
            end

            transition.to(grpMenu, {y=display.contentCenterY - 50, time=700, transition=easing.outBack, onComplete=function()
                for i=1, 3 do
                    local sptBonus = TBL_BONUS[i]
                    sptBonus:addEventListener("touch", sptBonus)
                end
            end})

        end})
    end
    

	return bonus
end


return Bonus