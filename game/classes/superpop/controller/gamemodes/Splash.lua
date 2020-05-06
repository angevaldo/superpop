local Composer = require "composer"
local Widget = require "widget"


local Trt = require "lib.Trt"
local Vector2D = require "lib.Vector2D"


local Controller = require "classes.superpop.business.Controller"
local Util = require "classes.superpop.business.Util"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"
local Particle = require "classes.superpop.entities.Particle"
local Continue = require "classes.superpop.controller.animations.Continue"


local random = math.random
local round = math.round
local sqrt = math.sqrt
local ceil = math.ceil


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local _NUM_SCORE_MIN_TO_CONTINUE = Constants.NUM_SCORE_MIN_TO_CONTINUE
local _NUM_SCREEN_PADDING_HORIZONTAL = Constants.NUM_SCREEN_PADDING_HORIZONTAL
local _NUM_SCREEN_PADDING_VERTICAL = Constants.NUM_SCREEN_PADDING_VERTICAL
local _NUM_SCORE_MAX_FOR_EACH_PARTICLE = Constants.NUM_SCORE_MAX_FOR_EACH_PARTICLE


-- GAMEMODE CONSTANTS
local _NUM_TIME_MATRIX_FX_SCALE = 2.5
local _NUM_TIME_MATRIX_FX_MOVEMENT = 750
local _NUM_TIME_MATRIX_FX_INITIAL = 2000
local _NUM_TIME_MATRIX_FX_MIN = 1200
local _NUM_TIME_MATRIX_FX_REDUCTION_PER_CYCLE = 40
local _NUM_TIME_MATRIX_FX_PER_PARTICLE = 200
local _NUM_FACTOR_COINS_APPEAR = 10 -- min 1. Small numbers = more chances to coin
local _NUM_QUANTITY_PARTICLES_MIN_TO_SPECIAL_POWER = 6
local _NUM_MIN_DISTANCE_BETEWEEN_PARTICLES = 150
local _TBL_PROBABILITIES_QUANTITY_PARTICLES_PER_CYCLE = {1,2,3,3,4,4,5,5,5,6,6,7}


local function _onSuspendResume(event) end


local Gamemode = {}


local _onSptSpecialTrail = function(self, event)
    if event.phase == "ended" then
        if self and self.parent and self.parent.remove then
            self.parent:remove(self)
            self = nil
        end
    end
end


function Gamemode:new(params)


    system.activate("multitouch")
    local nPlayed = globals_persistence:get("nPlayedSplash") + 1
    globals_persistence:set("nPlayedSplash", nPlayed)


    local grpView = params.grpView

    local gamemode = display.newGroup()
    grpView:insert(gamemode)

    local scenario = params.scenario
    scenario:start()

    
    local sptHand
    local linHand
    local continue


    local numTimeOnScreen = _NUM_TIME_MATRIX_FX_INITIAL
    local numTimeTotal = 0
    local numTimeScale = .5 + (_NUM_TIME_MATRIX_FX_INITIAL - numTimeOnScreen) * .5
    local numScoreT = 0
    local isGameOver = false
    local isPreGameOver = false
    local isContinue = false
    local numCountCoinsCollected = 0
    local tblObjects = {}

    local _CANCEL_MOVEMENT
    local _SHT_THEME_CURRENT = Controller:getSheet()
    local _IS_INIT = params.isInit

    local _starSortPositionTo = function(self)
        local vecTo = Vector2D:new(0, 400)
        vecTo:rotateVector(random(360))
        self.vecTo = vecTo

        local vecFrom = Vector2D:Mult(vecTo, random(2) * .025)
        self.x, self.y = vecFrom.x, vecFrom.y
        self.xScale, self.yScale = .2, .2
        self.alpha = 0
        self.rotation = Vector2D:Vec2deg(vecTo)
        self.delay = random(0, 8) * 100
        self.numTime = random(30, 35) * 100
    end

    local _starAnimate = function(self)
        self:sortPosition()
        Trt.to(self, {x=self.vecTo.x, y=self.vecTo.y, time=self.numTime, delay=self.delay, xScale=4, yScale=1.5, alpha=1, transition="inExpo", onComplete=function()
            if self.vecTo then
                self:animate()
            end
        end})
    end

    local _getStarField = function()
        local grpStarField = display.newGroup()
        for i=1,30 do
            local sptStar = display.newSprite(_SHT_THEME_CURRENT, { {name="standard", frames={6} } })
            sptStar.width = sptStar.width * random(1, 3)
            sptStar.animate = _starAnimate
            sptStar.sortPosition = _starSortPositionTo
            grpStarField:insert(sptStar)

            sptStar:animate()
        end

        return grpStarField
    end


    -- PAUSE CONTROL
    local btnPauseEvent = function(event) end
    _onSuspendResume = function(event)
        if "applicationSuspend" == event.type and btnPauseEvent then
            btnPauseEvent({phase="ended"})
        end
    end
    local btnPause = {}
    Runtime:addEventListener("system", _onSuspendResume)
    globals_btnBackRelease = function() if btnPauseEvent then btnPauseEvent({phase="ended"}) end end

    local grpContent = display.newGroup()
    gamemode:insert(grpContent)

    local grpBG = display.newGroup()
    grpContent:insert(grpBG)

    local _rotateFx = function() end
    _rotateFx = function(self, numRot, numTime)
        Trt.to(self, {rotation=self.rotation + numRot, time=numTime, onComplete=function()
            if self and self.rotateFx then
                self:rotateFx(numRot, numTime)
            end
        end})
    end

    local grpFx1 = display.newGroup()
    grpBG:insert(grpFx1)
    for i=1, 8 do
        local numFrame = random(5)
        local imgFx = display.newSprite(_SHT_THEME_CURRENT, { {name="standard", frames={0+numFrame} } })
        imgFx.anchorX, imgFx.anchorY = 0, .5
        imgFx.x, imgFx.y = 0, 0
        imgFx:scale(2, 2)
        imgFx.alpha = random(0, 15) * .01
        imgFx.rotation = i * 45
        grpFx1:insert(imgFx)
    end
    grpFx1.rotateFx = _rotateFx
    grpFx1:scale(2, 2)
    grpBG:insert(grpFx1)

    local grpFx2 = display.newGroup()
    grpBG:insert(grpFx2)
    for i=1, 8 do
        local numFrame = random(5)
        local imgFx = display.newSprite(_SHT_THEME_CURRENT, { {name="standard", frames={0+numFrame} } })
        imgFx.anchorX, imgFx.anchorY = 0, .5
        imgFx.x, imgFx.y = 0, 0
        imgFx:scale(2, 2)
        imgFx.alpha = random(0, 15) * .01
        imgFx.rotation = i * 45
        grpFx2:insert(imgFx)
    end
    grpFx2.rotateFx = _rotateFx
    grpFx2:scale(2, 2)
    grpBG:insert(grpFx2)

    grpFx1:rotateFx(1500, 60000)
    grpFx2:rotateFx(-1500, 100000)

    grpBG:insert(_getStarField())


    local rctSize = display.newRect(grpBG, 0, 0, 2000, 2000)
    rctSize.anchorX, rctSize.anchorY = .5, .5
    rctSize.x, rctSize.y, rctSize.alpha = 0, 0, .01


    local grpHud = display.newGroup()
    gamemode:insert(grpHud)


    local _onRctBgTouch = function(self, event)
        local phase = event.phase
        if self.isActive then--phase == "began" then
            local sptTouch = display.newSprite(_SHT_UTIL, { {name="standard", frames={241} } })
            sptTouch.x, sptTouch.y = event.x, event.y
            grpHud:insert(sptTouch)

            transition.to(self, {time=150, onComplete=function()
                if self then
                    self.isActive = true
                end
            end})

            transition.to(sptTouch, {alpha=0, xScale=.001, yScale=.001, time=800, transition=easing.inQuad, onComplete=function()
                if sptTouch and grpHud.remove then
                    grpHud:remove(sptTouch)
                    sptTouch = nil
                end
            end})
        end
        self.isActive = false
    end
    local rctBg = display.newRect(grpHud, -10, -10, 350, 500)
    rctBg.anchorX, rctBg.anchorY = 0, 0
    rctBg.isActive = true
    rctBg.touch = _onRctBgTouch
    rctBg:addEventListener("touch", rctBg)
    transition.to(rctBg, {alpha=.01, time=300})

    grpBG.anchorChildren = true
    grpBG.anchorX, grpBG.anchorY = .5, .5
    grpBG.x, grpBG.y = display.contentCenterX, display.contentCenterY


    local sptTimer = display.newSprite(_SHT_UTIL, { {name="s", start=96, count=1} })
    sptTimer.anchorX, sptTimer.anchorY = .5, 0
    sptTimer.x, sptTimer.y = display.contentCenterX, Constants.TOP
    grpHud:insert(sptTimer)


    local grpShadow = display.newGroup()
    grpHud:insert(grpShadow)

    local tblTxtOptions = {
        parent = grpShadow,
        text = "0",
        font = Constants.TBL_STYLE.FAMILY,
        fontSize = 40,
        align = "left"
    }

    local txtScoreS1 = display.newText(tblTxtOptions)
    txtScoreS1:setFillColor(0, 0, 0, .65)
    txtScoreS1.anchorX, txtScoreS1.anchorY = 0, 1
    txtScoreS1.x, txtScoreS1.y = Constants.LEFT + 3.5, Constants.BOTTOM + 16.5

    local txtScoreS2 = display.newText(tblTxtOptions)
    txtScoreS2:setFillColor(0, 0, 0, .2)
    txtScoreS2.anchorX, txtScoreS2.anchorY = 0, 1
    txtScoreS2.x, txtScoreS2.y = Constants.LEFT + 1.5, Constants.BOTTOM + 14.5

    tblTxtOptions.parent = grpHud
    local txtScoreT = display.newText(tblTxtOptions)
    local tblColor = Constants.TBL_STYLE.COLOR
    txtScoreT:setFillColor(tblColor[1], tblColor[2], tblColor[3], tblColor[4])
    txtScoreT.anchorX, txtScoreT.anchorY = 0, 1
    txtScoreT.x, txtScoreT.y = Constants.LEFT + 2, Constants.BOTTOM + 15


    local _doMatrixEffect = {}
    local _onExplodedParticle = {}
    local _onHitScreenParticle = {}
    local _doPreGameOver = {}
    local _doGameOver = {}
    local _doContinue = {}
    local _doContinuePlay = {}
    local _move = {}
    local _sort = {}
    local _pause = {}
    local _removeObject = {}
    local _getNewPosition = {}
    local _createParticle = {}
    local _activateObjects = {}
    local _onSpriteTimer = {}


    _pause = function(self, isPause)
        scenario:pauseAll(isPause)

        for i=1, #tblObjects do
            tblObjects[i]:pause(isPause)
        end

        if isPause then
            Trt.pauseAll()
            sptTimer:pause()
        elseif Controller:getStatus() == 1 then
            Trt.resumeAll()
            if sptTimer.isActivate then
                sptTimer:play()
            end
            globals_btnBackRelease = function() if btnPauseEvent then btnPauseEvent({phase="ended"}) end end
        end
    end
    gamemode.pause = _pause

    _removeObject = function(self, particle)
        table.remove(tblObjects, particle.id)
        for i=1, #tblObjects do
            tblObjects[i].id = i
        end
        if #tblObjects == 0 then
            _move()
        end
        self:remove(particle)
        particle = nil
    end
    gamemode.removeObject = _removeObject

    _doMatrixEffect = function(isActive)
        if isActive then
            grpHud:remove(sptTimer)
            sptTimer = display.newSprite(_SHT_UTIL, { {name="s", start=96, count=50,  time=numTimeTotal * .2, loopCount=1} })
            grpHud:insert(sptTimer)
            sptTimer.anchorX, sptTimer.anchorY = .5, 0
            sptTimer.x, sptTimer.y = display.contentCenterX, Constants.TOP
            sptTimer.timeScale = numTimeScale
            sptTimer.sprite = _onSpriteTimer
            sptTimer:addEventListener("sprite", sptTimer)
            sptTimer:play()

            Trt.timeScaleAll(numTimeScale)
            if scenario and scenario.timeScaleAll then
                scenario:timeScaleAll(numTimeScale)
            end

            _activateObjects(true)
        else
            _activateObjects(false)

            if sptTimer and sptTimer.pause then
                sptTimer:pause()
                sptTimer.isActivate = false
            end

            Trt.timeScaleAll(_NUM_TIME_MATRIX_FX_SCALE * 2)
            if scenario and scenario.timeScaleAll then
                scenario:timeScaleAll(_NUM_TIME_MATRIX_FX_SCALE * 2)
            end

            sptTimer:removeEventListener("sprite")
        end
    end

    _onExplodedParticle = function(self, params)
        local numPercScore = 1 - (sptTimer.frame / 50)
        local numPoints = round(numPercScore * _NUM_SCORE_MAX_FOR_EACH_PARTICLE)

        if _IS_INIT then
            gamemode:pause(false)
            gamemode:remove(sptHand)
            gamemode:remove(linHand)
            sptHand = nil
            linHand = nil
            _IS_INIT = false
            transition.to(btnPause, {xScale=1, yScale=1, delay=400, time=600, transition=easing.outElastic})
        end

        local numSize = 15 + (15 * numPercScore)

        local tblTxtOptions = {
            parent = grpBG,
            text = "",
            width = 128,
            font = Constants.TBL_STYLE.FAMILY,
            fontSize = numSize,
            align = "center"
        }
        local txtScore = display.newText(tblTxtOptions)
        local tblColor = Constants.TBL_STYLE.COLOR
        txtScore:setFillColor(tblColor[1], tblColor[2], tblColor[3], tblColor[4])
        txtScore.anchorX, txtScore.anchorY = .5, .5
        txtScore.x, txtScore.y = params.x - grpBG.x, params.y - grpBG.y
        txtScore.text = "+"..numPoints
        transition.to(txtScore, {time=300, onComplete=function()
            transition.to(txtScore, {time=500, onComplete=function()
                transition.to(txtScore, {alpha=0, time=600, onComplete=function()
                    if gamemode and gamemode.remove then
                        gamemode:remove(txtScore)
                        txtScore = nil
                    end
                end})
            end})
        end})

        numScoreT = numScoreT + numPoints
        txtScoreT.text = numScoreT
        txtScoreS1.text = numScoreT
        txtScoreS2.text = numScoreT

        if Particle.count == 0 then
            sptTimer:pause()
            sptTimer.isActivate = false
        end

        -- COINS
        if random(_NUM_FACTOR_COINS_APPEAR) == 1 then
            globals_persistence:addCoins(1)
            numCountCoinsCollected = numCountCoinsCollected + 1

            Jukebox:dispatchEvent({name="playSound", id="coin"})

            local sptCoin = display.newSprite(_SHT_UTIL, { {name="s", start=92, count=1} })
            gamemode:insert(sptCoin)
            sptCoin.x, sptCoin.y = params.x, params.y
            local yTo = sptCoin.y - 80
            transition.to(sptCoin, {time=300, y=yTo, transition=easing.outExpo, onComplete=function()
                transition.to(sptCoin, {time=400, xScale=.001, yScale=.001, transition=easing.inElastic, onComplete=function()
                    if sptCoin and gamemode.remove then
                        gamemode:remove(sptCoin)
                        sptCoin = nil
                    end
                end})
            end})
        end

        -- SPECIAL POWER
        if params.isSpecial then
            rctBg.alpha = 1
            transition.to(rctBg, {alpha=.01, delay=200, time=300})
            Jukebox:dispatchEvent({name="playSound", id="shock"})

            local vo = Vector2D:new(params.x, params.y)

            for i=1, #tblObjects do
                if i ~= params.id then
                    local sptSpecial = display.newSprite(_SHT_UTIL, { {name="s", start=22, count=17, time=500, loopCount=1} })
                    sptSpecial:play()
                    sptSpecial.rotation = random(360)
                    tblObjects[i]:insert(sptSpecial)

                    local vd = Vector2D:new(tblObjects[i].x - vo.x, tblObjects[i].y - vo.y)
                    local numQttObjects = ceil(vd:magnitude()  * .014)
                    vd:normalize()
                    vd:mult(70)
                    local vn = 0
                    for j=1, numQttObjects do
                        vn = Vector2D:Add(Vector2D:Mult(vd, j-1), vo)

                        local sptSpecialTrail = display.newSprite(_SHT_UTIL, { {name="s", start=5, count=17, time=300, loopCount=1} })
                        gamemode:insert(sptSpecialTrail)
                        sptSpecialTrail.anchorX, sptSpecialTrail.anchorY = .2, .5
                        sptSpecialTrail.x, sptSpecialTrail.y = vn.x, vn.y
                        sptSpecialTrail.rotation = Vector2D:Vec2deg(vd)
                        sptSpecialTrail.sprite = _onSptSpecialTrail
                        sptSpecialTrail:addEventListener("sprite", sptSpecialTrail)
                        transition.to(sptSpecialTrail, {time=60*(j-1), onComplete=function()
                            if sptSpecialTrail and sptSpecialTrail.play then
                                sptSpecialTrail:play()
                            end
                        end})
                    end

                    tblObjects[i][1]:touch({phase="began"})
                end
            end
        end
    end
    gamemode.onExplodedParticle = _onExplodedParticle

    _getNewPosition = function()
        local x = 0
        local y = 0
        local count = 0
        repeat
            x = _NUM_SCREEN_PADDING_HORIZONTAL + random(Constants.RIGHT - _NUM_SCREEN_PADDING_HORIZONTAL)
            y = _NUM_SCREEN_PADDING_VERTICAL + random(Constants.BOTTOM - _NUM_SCREEN_PADDING_VERTICAL)
            local isClose = false
            
            for i=1, #tblObjects do
                local xo = tblObjects[i].numToX - x
                local yo = tblObjects[i].numToY - y
                if sqrt(xo*xo + yo*yo) < _NUM_MIN_DISTANCE_BETEWEEN_PARTICLES then
                    isClose = true
                    break
                end
            end
            count = count + 1
        until not isClose or count > 20
        return x, y
    end

    _createParticle = function(isSpecial)
        local x, y = _getNewPosition()

        local params = {isSpecial=isSpecial, numFromX=grpBG.x, numFromY=grpBG.y, numToX=x, numToY=y, numTimeOnScreen=numTimeTotal}
        local particle = Particle:new(params)
        gamemode:insert(particle)

        particle.id = #tblObjects+1
        tblObjects[particle.id] = particle
        _NUM_COUNT_OBSTACLES = #tblObjects
    end

    _activateObjects = function(isActivate)
        sptTimer.isActivate = isActivate
        
        for i=1, #tblObjects do
            tblObjects[i]:activate(isActivate)
        end
    end

    _onSpriteTimer = function(self, event)
        if event.phase == "ended" then
            _doMatrixEffect(false)
        end
    end

    _sort = function(count)
        local numQttObjects = count or _TBL_PROBABILITIES_QUANTITY_PARTICLES_PER_CYCLE[random(#_TBL_PROBABILITIES_QUANTITY_PARTICLES_PER_CYCLE)]
        numTimeOnScreen = numTimeOnScreen > _NUM_TIME_MATRIX_FX_MIN and numTimeOnScreen - _NUM_TIME_MATRIX_FX_REDUCTION_PER_CYCLE or numTimeOnScreen
        numTimeTotal = numTimeOnScreen + numQttObjects * _NUM_TIME_MATRIX_FX_PER_PARTICLE
        numTimeScale = .2 + (_NUM_TIME_MATRIX_FX_INITIAL - numTimeOnScreen) * .0005

        for i=1, numQttObjects do
            _createParticle(numQttObjects > _NUM_QUANTITY_PARTICLES_MIN_TO_SPECIAL_POWER and i == numQttObjects)
        end

        Trt.timeScaleAll(_NUM_TIME_MATRIX_FX_SCALE)

        if _CANCEL_MOVEMENT ~= nil then 
            Trt.cancel(_CANCEL_MOVEMENT) 
            _CANCEL_MOVEMENT = nil 
        end

        _CANCEL_MOVEMENT = Trt.to(gamemode, {time=numTimeTotal * .5, onComplete=function()

            _doMatrixEffect(true)

            if _IS_INIT then
                gamemode:pause(true)

                local function _moveHand(self) 
                    if tblObjects and tblObjects[1] and self and self.setFrame and linHand then
                        local vd = {35, -35}
                        local v1 = {tblObjects[1].x + vd[1] - 10, tblObjects[1].y + vd[2] - 10}
                        local v2 = {tblObjects[1].x - vd[1] - 10, tblObjects[1].y - vd[2] - 10}
                        self.alpha = 0
                        self:setFrame(1)
                        self.x, self.y = v1[1], v1[2]

                        linHand.alpha, linHand.xScale = 0, .001
                        linHand.x, linHand.y = v1[1] + 15, v1[2] + 9

                        self:play()
                        transition.to(self, {alpha=1, time=300, onComplete=function()
                            transition.to(self, {time=200, onComplete=function()
                                if linHand and linHand.alpha then
                                    linHand.alpha = 1
                                    transition.to(linHand, {xScale=1, time=600, transition=easing.outQuad})
                                    transition.to(self, {x=v2[1], y=v2[2], time=600, transition=easing.outQuad, onComplete=function()
                                        transition.to(linHand, {alpha=0, time=300})
                                        transition.to(self, {alpha=0, time=300, onComplete=function()
                                            if self and self.moveHand then
                                                self:moveHand()
                                            end
                                        end})
                                    end})
                                end
                            end})
                        end})
                    end
                end

                linHand = display.newLine(gamemode, 100,100, 200,100)
                linHand.anchorX, linHand.anchorY = 0, .5
                linHand.rotation = 135
                linHand:setStrokeColor(1, .3)
                linHand.strokeWidth = 11

                sptHand = display.newSprite(_SHT_UTIL, { {name="standard", frames={93,94}, time=500, loopCount=1} })
                sptHand.anchorX, sptHand.anchorY = .5, 0
                sptHand.alpha = 0
                sptHand.rotation = -45
                sptHand.moveHand = _moveHand
                gamemode:insert(sptHand)
                sptHand:moveHand()
            end

        end})
    end

    _move = function(count)        
        local x, y = random(display.contentCenterX - 100, display.contentCenterX + 100), random(display.contentCenterY - 100, display.contentCenterY + 100)

        Trt.timeScaleAll(_NUM_TIME_MATRIX_FX_SCALE)
        
        if scenario and scenario.moveAll then
            scenario:moveAll({x=x, y=y, time=_NUM_TIME_MATRIX_FX_MOVEMENT, transition="outQuart"})
            local strID = "move"..random(7)
            Jukebox:dispatchEvent({name="playSound", id=strID})
        end
        if _CANCEL_MOVEMENT ~= nil then 
            Trt.cancel(_CANCEL_MOVEMENT) 
            _CANCEL_MOVEMENT = nil 
        end
        _CANCEL_MOVEMENT = Trt.to(grpBG, {x=x, y=y, time=_NUM_TIME_MATRIX_FX_MOVEMENT, transition="outQuart", onComplete=function()
            _sort(count)
        end})

        if sptTimer and sptTimer.setFrame then
            sptTimer:setFrame(1)
        end
    end

    _onHitScreenParticle = function(self, params)
        _doPreGameOver()
    end
    gamemode.onHitScreenParticle = _onHitScreenParticle


    _doGameOver = function()
        if not isGameOver then
            system.deactivate("multitouch")

            isGameOver = true

            local options = {
                isModal = true,
                effect = "fade",
                time = 0,
                params = {numScore=numScoreT, tblObjects=tblObjects, numCoinsCollected=numCountCoinsCollected}
            }
            Composer.showOverlay("classes.superpop.controller.gamemodes.SplashResults", options)
        end
    end
    gamemode.doGameOver = _doGameOver


    _doPreGameOver = function()
        if not isPreGameOver then
            isPreGameOver = true

            Runtime:removeEventListener("system", _onSuspendResume)

            for i=1, #tblObjects do
                tblObjects[i].isVisible = false
                if tblObjects[i][1][1].sequence == "s" then
                    local sptSplash = display.newSprite(_SHT_UTIL, { {name="standard", frames={random(196,198)} } })
                    sptSplash.anchorX, sptSplash.anchorY = .5, .5
                    sptSplash.x, sptSplash.y = tblObjects[i].x, tblObjects[i].y
                    sptSplash.rotation = random(360)
                    sptSplash:setFillColor(tblObjects[i].tblColor[1], tblObjects[i].tblColor[2], tblObjects[i].tblColor[3])
                    local numScaleTo = tblObjects[i].numScale * 1.2
                    local numScaleFrom = numScaleTo * .8
                    sptSplash:scale(numScaleFrom, numScaleFrom)
                    Trt.to(sptSplash, {xScale=numScaleTo, yScale=numScaleTo, time=500, transition="outExpo", onComplete=function()
                        Trt.to(sptSplash, {alpha=0, time=1000, onComplete=function()
                            if sptSplash and gamemode and gamemode.remove then
                                gamemode:remove(sptSplash)
                            end
                        end})
                    end})
                    gamemode:insert(sptSplash)

                    local numId = random(2)
                    timer.performWithDelay(50 * (i-1), function()
                        Jukebox:dispatchEvent({name="playSound", id="splash"..numId})
                    end, 1)
                end
            end

            _activateObjects(false)

            transition.to(grpHud, {alpha=0, time=200})
            transition.to(grpShadow, {alpha=0, time=100, onComplete=function()
                gamemode:pause(true)
                if isContinue or numScoreT < _NUM_SCORE_MIN_TO_CONTINUE then --isContinue
                    _doGameOver()
                else
                    continue = Continue:new({grpView=gamemode})
                    if continue == nil then
                        _doGameOver()
                    end
                end
            end})
        end
    end


    _doContinue = function()
        local grpCountdown = display.newGroup()
        grpView:insert(grpCountdown)

        if continue then
            gamemode:remove(continue)
        end
        continue = nil

        local rctOverlay = display.newRect(grpCountdown, -10, -10, 350, 500)
        rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
        rctOverlay:setFillColor(0, .5)

        local tblTxtOptions = {
            parent = grpCountdown,
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
                    transition.to(grpCountdown, {alpha=0, time=300, onComplete=function()
                        if grpView and grpView.remove then
                            grpView:remove(grpCountdown)
                            grpCountdown = nil
                        end
                    end})
                    transition.to(txtCountDown, {alpha=0, xScale=.2, yScale=.2, time=150, onComplete=function()
                        if grpView and grpView.remove then
                            grpView:remove(txtCountDown)
                            txtCountDown = nil
                        end
                        _doContinuePlay()
                    end})
                else
                    doCount()
                end
            end})
        end
        transition.to(grpView, {time=200, onComplete=doCount})
    end
    gamemode.doContinue = _doContinue


    _doContinuePlay = function()
        isPreGameOver = false
        isGameOver = false
        isContinue = true

        rctBg.alpha = 1

        transition.to(grpHud, {alpha=1, time=200})
        transition.to(grpShadow, {alpha=1, time=100})

        transition.to(rctBg, {alpha=.01, delay=200, time=300, onComplete=function()
            if gamemode and gamemode.pause then
                for i=#tblObjects, 1, -1 do
                    gamemode:removeObject(tblObjects[i])
                end
                Particle.count = 0

                gamemode:pause(false)
                Runtime:addEventListener("system", _onSuspendResume)
            end
        end})

        for i=#tblObjects, 1, -1 do
            tblObjects[i]:hide(true)
        end

        Jukebox:dispatchEvent({name="playMusic", id=1, status=1})
    end


    btnPauseEvent = function(event)
        if "ended" == event.phase and Controller:validateNextStatus(2) and btnPause and btnPause.xScale == 1 then
            local options = {
                isModal = true,
                effect = "fade",
                time = 0,
            }
            Composer.showOverlay("classes.superpop.controller.gamemodes.SplashPause", options)
        end

        return true
    end
    btnPause = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 51,
        overFrame = 52,
        onEvent = btnPauseEvent
    }
    grpHud:insert(btnPause)
    btnPause.anchorX, btnPause.anchorY = .5, .5
    btnPause.x, btnPause.y = Constants.RIGHT - btnPause.width * .4, Constants.BOTTOM - btnPause.height * .3
    btnPause.alpha = 1
    btnPause:scale(.001, .001)
    if not _IS_INIT then
        transition.to(btnPause, {xScale=1, yScale=1, delay=400, time=600, transition=easing.outElastic})
    end


    Util:hideStatusbar()
    Controller:setStatus(1, true)
    Trt.timeScaleAll(1)
    _move(1)


    Jukebox:dispatchEvent({name="playMusic", id=1, status=1})

    
    Particle.count = 0


    return gamemode
end


return Gamemode