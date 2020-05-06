local Composer = require "composer"
local Widget = require "widget"


local Trt = require "lib.Trt"
local Vector2D = require "lib.Vector2D"


local Controller = require "classes.superpop.business.Controller"
local Util = require "classes.superpop.business.Util"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"
local Particle = require "classes.superpop.entities.Particle"
local Bomb = require "classes.superpop.entities.Bomb"
local Continue = require "classes.superpop.controller.animations.Continue"


local random = math.random
local round = math.round
local sqrt = math.sqrt
local ceil = math.ceil
local pow = math.pow


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local _NUM_SCORE_INTERVAL_TO_SPLASH_BONUS_BOMB_MODE = Constants.NUM_SCORE_INTERVAL_TO_SPLASH_BONUS_BOMB_MODE
local _NUM_SCORE_MIN_TO_CONTINUE = Constants.NUM_SCORE_MIN_TO_CONTINUE
local _NUM_SCREEN_PADDING_HORIZONTAL = Constants.NUM_SCREEN_PADDING_HORIZONTAL
local _NUM_SCREEN_PADDING_VERTICAL = Constants.NUM_SCREEN_PADDING_VERTICAL
local _NUM_SCORE_MAX_FOR_EACH_PARTICLE = Constants.NUM_SCORE_MAX_FOR_EACH_PARTICLE


-- GAMEMODE CONSTANTS
local _NUM_TIME_MATRIX_FX_SCALE = 2.5
local _NUM_TIME_MATRIX_FX_MOVEMENT = 1000
local _NUM_TIME_MATRIX_FX_INITIAL = 1800
local _NUM_TIME_MATRIX_FX_MIN = 1200
local _NUM_TIME_MATRIX_FX_REDUCTION_PER_CYCLE = 30
local _NUM_TIME_MATRIX_FX_PER_PARTICLE = 250 
local _NUM_FACTOR_COINS_APPEAR = 20 -- min 1. Small numbers = more chances to coin
local _NUM_QUANTITY_PARTICLES_MIN_TO_SPECIAL_POWER = 6
local _NUM_MIN_DISTANCE_BETEWEEN_PARTICLES = 120
local _TBL_PROBABILITIES_QUANTITY_PARTICLES_PER_CYCLE = {1,2,3,3,3,4,4,5,6,7}
local _TBL_PROBABILITIES_QUANTITY_BOMBS_PER_CYCLE = {0,0,1,2,2,3,4}


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
    local nPlayed = globals_persistence:get("nPlayedBomb") + 1
    globals_persistence:set("nPlayedBomb", nPlayed)


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
    local isPreGameOver = false
    local isGameOver = false
    local isGamingOver = false
    local isContinue = false
    local numCountSplashLeft = 0
    local numCountCoinsCollected = 0
    local numScoreNextSplashBonusBombMode = _NUM_SCORE_INTERVAL_TO_SPLASH_BONUS_BOMB_MODE
    local tblObjects = {}

    local _CANCEL_MOVEMENT
    local _CHANNEL_BURN
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

    local grpBGFx = display.newGroup()
    grpBG:insert(grpBGFx)

    local grpFx1 = display.newGroup()
    grpBGFx:insert(grpFx1)
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
    grpBGFx:insert(grpFx1)

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
    grpBGFx:insert(grpFx2)

    grpFx1:rotateFx(1500, 60000)
    grpFx2:rotateFx(-1500, 100000)

    grpBGFx:insert(_getStarField())


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


    local grpSplashLeft = display.newGroup()
    grpHud:insert(grpSplashLeft)
    for i=1, 3 do
        local sptSplashLeft = display.newSprite(_SHT_UTIL, { {name="standard", frames={252,253} } })
        grpSplashLeft:insert(sptSplashLeft)
        sptSplashLeft.x, sptSplashLeft.y = 46 * i, 50
        sptSplashLeft.rotation = random(360)
        sptSplashLeft:scale(.001, .001)
        transition.to(sptSplashLeft, {xScale=1, yScale=1, delay=300+100*i, time=600, transition=easing.outElastic})
    end
    grpSplashLeft.anchorX, grpSplashLeft.anchorY = .5, 0
    grpSplashLeft.x, grpSplashLeft.y = display.contentCenterX - grpSplashLeft.width, Constants.TOP


    local _doMatrixEffect = {}
    local _onExplodedParticle = {}
    local _onExplodedBomb = {}
    local _onHitScreenParticle = {}
    local _onHitScreenBomb = {}
    local _doPreGameOver = {}
    local _doGameOver = {}
    local _doContinue = {}
    local _doContinuePlay = {}
    local _move = {}
    local _sort = {}
    local _pause = {}
    local _removeObject = {}
    local _activateObjects = {}
    local _createParticle = {}
    local _createBomb = {}
    local _getNewPosition = {}
    local _getNewPositionBomb = {}
    local _onSpriteTimer = {}


    _pause = function(self, isPause)
        scenario:pauseAll(isPause)
        
        if _CHANNEL_BURN ~= nil and tonumber(_CHANNEL_BURN) and _CHANNEL_BURN > 0 then
            audio.stop(_CHANNEL_BURN)
            _CHANNEL_BURN = nil
        end

        for i=1, #tblObjects do
            tblObjects[i]:pause(isPause)
        end

        if isPause then
            Trt.pauseAll()
            sptTimer:pause()
        else
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
        if particle.type == 2 and _CHANNEL_BURN ~= nil and tonumber(_CHANNEL_BURN) and _CHANNEL_BURN > 0 then
            audio.stop(_CHANNEL_BURN)
            _CHANNEL_BURN = nil
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
            text = "+"..numPoints,
            font = Constants.TBL_STYLE.FAMILY,
            fontSize = numSize,
            align = "center"
        }
        local txtScore = display.newText(tblTxtOptions)
        local tblColor = Constants.TBL_STYLE.COLOR
        txtScore:setFillColor(tblColor[1], tblColor[2], tblColor[3], tblColor[4])
        txtScore.anchorX, txtScore.anchorY = .5, .5
        txtScore.x, txtScore.y = params.x - grpBG.x, params.y - grpBG.y
        transition.to(txtScore, {time=800, onComplete=function()
            transition.to(txtScore, {alpha=0, time=600, onComplete=function()
                if gamemode and gamemode.remove then
                    gamemode:remove(txtScore)
                    txtScore = nil
                end
            end})
        end})

        numScoreT = numScoreT + numPoints
        txtScoreT.text = numScoreT
        txtScoreS1.text = numScoreT
        txtScoreS2.text = numScoreT

        if Particle.count == 0 then
            _doMatrixEffect(false)
        end

        -- BONUS 100 POINTS
        if numScoreT >= numScoreNextSplashBonusBombMode and numCountSplashLeft > 0 then
            numScoreNextSplashBonusBombMode = numScoreNextSplashBonusBombMode + _NUM_SCORE_INTERVAL_TO_SPLASH_BONUS_BOMB_MODE

            numCountSplashLeft = numCountSplashLeft - 1
            sptSplashLeft = grpSplashLeft[numCountSplashLeft + 1]
            sptSplashLeft:setFrame(1)
            sptSplashLeft:scale(.001, .001)
            if sptSplashLeft._TRT_CANCEL ~= nil then
                transition.cancel(sptSplashLeft._TRT_CANCEL)
                sptSplashLeft._TRT_CANCEL = nil
            end
            sptSplashLeft._TRT_CANCEL = transition.to(sptSplashLeft, {xScale=1, yScale=1, time=600, transition=easing.outElastic})

            Jukebox:dispatchEvent({name="playSound", id="positive"})
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
                if i ~= params.id and tblObjects[i].type == 1 then
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


    local _NUM_SHAKE_OLD_X, _NUM_SHAKE_OLD_Y, _NUM_SHAKE_DX, _NUM_SHAKE_DY = grpView.x, grpView.y, grpView.x, grpView.y
    local _NUM_SHAKE_COUNTER = 0
    local _doShake = function() end
    _doShake = function(numTime)
        _NUM_SHAKE_COUNTER = _NUM_SHAKE_COUNTER - .1
        _NUM_SHAKE_DX = pow (1, _NUM_SHAKE_COUNTER) * (random(2) == 1 and 4 or -4)
        _NUM_SHAKE_DY = pow (1, _NUM_SHAKE_COUNTER) * (random(2) == 1 and 4 or -4)
        numTime = numTime - 2

        grpView.x, grpView.y = _NUM_SHAKE_OLD_X + _NUM_SHAKE_DX, _NUM_SHAKE_OLD_Y + _NUM_SHAKE_DY
        grpView._CANCEL_SHAKE = timer.performWithDelay(numTime, function()
            if gamemode then
                if _NUM_SHAKE_COUNTER > -6 then
                    _doShake(numTime)
                else
                    grpView.x, grpView.y = _NUM_SHAKE_OLD_X, _NUM_SHAKE_OLD_Y
                end
            end
        end, 1)
    end
    local function _doShakeAnime()
        _NUM_SHAKE_COUNTER = 6
        if grpView._CANCEL_SHAKE ~= nil then 
            timer.cancel(grpView._CANCEL_SHAKE)
            grpView._CANCEL_SHAKE = nil 
        end
        _doShake(60)
    end

    _onExplodedBomb = function(self, params)
        isGamingOver = true

        local sptLight = display.newSprite(_SHT_UTIL, { {name="standard", frames={3} } })
        sptLight:scale(.001, .001)
        sptLight.x, sptLight.y = params.x, params.y
        transition.to(sptLight, {xScale=.8, yScale=.8, time=600, transition=easing.outBack, onComplete=function()
            transition.to(sptLight, {xScale=4, yScale=4, time=400, transition=easing.inBack})
        end})

        _activateObjects(false)
        scenario:pauseAll(true)
        Trt.pauseAll()

        if sptTimer and sptTimer.pause then
        	sptTimer:pause()
        end

        _doShakeAnime()
        Jukebox:dispatchEvent({name="playSound", id="swoosh"})

        transition.to(sptLight, {time=900, onComplete=function()
            rctBg.alpha = 1
            sptLight.isVisible = false

            if grpView._CANCEL_SHAKE ~= nil then
                transition.cancel(grpView._CANCEL_SHAKE)
                grpView._CANCEL_SHAKE = nil
            end
            if _CHANNEL_BURN ~= nil and tonumber(_CHANNEL_BURN) and _CHANNEL_BURN > 0 then
                audio.stop(_CHANNEL_BURN)
                _CHANNEL_BURN = nil
            end
            Jukebox:dispatchEvent({name="playSound", id="bomb"})

            for i=#tblObjects, 1, -1 do
                tblObjects[i]:hide(true)
            end

            transition.to(rctBg, {delay=100, time=100, alpha=0, onComplete=function()
                _doPreGameOver()
            end})

        end})
    end
    gamemode.onExplodedBomb = _onExplodedBomb

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
        until not isClose or count > 30
        return x, y
    end

    _createParticle = function(isSpecial)
        local x, y = _getNewPosition()

        local params = {isSpecial=isSpecial, numFromX=grpBG.x, numFromY=grpBG.y, numToX=x, numToY=y, numTimeOnScreen=numTimeTotal}
        local particle = Particle:new(params)
        gamemode:insert(particle)

        particle.id = #tblObjects+1
        tblObjects[particle.id] = particle
    end

    _createBomb = function(isBoing)
        local x, y = _getNewPosition()

        local params = {numFromX=grpBG.x, numFromY=grpBG.y, numToX=x, numToY=y, numTimeOnScreen=numTimeTotal, isBoing=isBoing}
        local bomb = Bomb:new(params)
        gamemode:insert(bomb)

        bomb.id = #tblObjects+1
        tblObjects[bomb.id] = bomb
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

        -- PARTICLES
        for i=1, numQttObjects do
            _createParticle(numQttObjects > _NUM_QUANTITY_PARTICLES_MIN_TO_SPECIAL_POWER and i == numQttObjects)
        end

        -- BOMBS
        if count == nil then
            local numQttBombs = count or _TBL_PROBABILITIES_QUANTITY_BOMBS_PER_CYCLE[random(#_TBL_PROBABILITIES_QUANTITY_BOMBS_PER_CYCLE)]
            for i=1, numQttBombs do
                _createBomb(i==1)
            end
            if numQttBombs > 0 then
                if _CHANNEL_BURN ~= nil and tonumber(_CHANNEL_BURN) and _CHANNEL_BURN > 0 then
                    audio.stop(_CHANNEL_BURN)
                    _CHANNEL_BURN = nil
                end
                _CHANNEL_BURN = Jukebox:dispatchEvent({name="playSound", id="burn"})
            end
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

    _onHitScreenBomb = function(self, params)
        local bomb = params.bomb
        Trt.to(bomb, {time=1200, x=bomb.xFrom, y=bomb.yFrom, xScale=.001, yScale=.001, transition="inQuart", onComplete=function()
            if gamemode and gamemode.removeObject and bomb then
                gamemode:removeObject(bomb)
            end
        end})
    end
    gamemode.onHitScreenBomb = _onHitScreenBomb

    _onHitScreenParticle = function(self, params)
        if not isGameOver then
            local particle = params.particle

            numCountSplashLeft = numCountSplashLeft + 1

            local sptSplash = display.newSprite(_SHT_UTIL, { {name="standard", frames={random(196,198)} } })
            gamemode:insert(sptSplash)
            sptSplash.anchorX, sptSplash.anchorY = .5, .5
            sptSplash.x, sptSplash.y = particle.x, particle.y
            sptSplash.rotation = random(360)
            sptSplash:setFillColor(particle.tblColor[1], particle.tblColor[2], particle.tblColor[3])
            local numScaleTo = particle.numScale
            local numScaleFrom = numScaleTo * .8
            sptSplash:scale(numScaleFrom, numScaleFrom)
            transition.to(sptSplash, {xScale=numScaleTo, yScale=numScaleTo, time=500, transition=easing.outExpo, onComplete=function()
                transition.to(sptSplash, {alpha=0, time=1000, transition=easing.outQuad, onComplete=function()
                    if gamemode and gamemode.remove then
                        gamemode:remove(sptSplash)
                    end
                    sptSplash = nil
                end})
                if not isGameOver and not isPreGameOver and Controller:getStatus() == 1 then
                    if numCountSplashLeft > 2 then
                        _doPreGameOver()
                    end
                end
            end})

            if gamemode and gamemode.removeObject and particle then
                gamemode:removeObject(particle)
            end

            if Particle.count == 0 then
                local numSplashID = random(2)
                Jukebox:dispatchEvent({name="playSound", id="splash"..numSplashID})
            end

            local sptSplashLeft
            if numCountSplashLeft < 4 then
                sptSplashLeft = grpSplashLeft[numCountSplashLeft]
                sptSplashLeft:setFrame(2)
                sptSplashLeft:scale(.001, .001)
            else
                return
            end

            if numCountSplashLeft > 2 and not isGamingOver then
                isGamingOver = true
                _activateObjects(false)
                scenario:pauseAll(true)
                Trt.pauseAll()

                -- ADD ANOTHER SPLASHES
                local particleTemp 
                for i=#tblObjects, 1, -1 do
                    particleTemp = tblObjects[i]
                    if particleTemp.type == 1 and particleTemp[1][1].sequence == "s" then
                        local sptSplash = display.newSprite(_SHT_UTIL, { {name="standard", frames={random(196,198)} } })
                        gamemode:insert(sptSplash)
                        sptSplash.anchorX, sptSplash.anchorY = .5, .5
                        sptSplash.x, sptSplash.y = particleTemp.x, particleTemp.y
                        sptSplash.rotation = random(360)
                        sptSplash:setFillColor(particleTemp.tblColor[1], particleTemp.tblColor[2], particleTemp.tblColor[3])
                        local numScaleTo = particleTemp.numScale
                        local numScaleFrom = numScaleTo * .8
                        sptSplash:scale(numScaleFrom, numScaleFrom)
                        transition.to(sptSplash, {xScale=numScaleTo, yScale=numScaleTo, time=500, transition=easing.outExpo, onComplete=function()
                            transition.to(sptSplash, {alpha=0, time=1000, onComplete=function()
                                if sptSplash and gamemode and gamemode.remove then
                                    gamemode:remove(sptSplash)
                                end
                            end})
                        end})
                        particleTemp:hide(true)
                    else
                        particleTemp:pause(true)
                    end
                end
            end

            transition.to(gamemode, {time=100*(numCountSplashLeft-1), onComplete=function()
                if sptSplashLeft then
                    Jukebox:dispatchEvent({name="playSound", id="negation"})
                    if sptSplashLeft._TRT_CANCEL ~= nil then
                        transition.cancel(sptSplashLeft._TRT_CANCEL)
                        sptSplashLeft._TRT_CANCEL = nil
                    end
                    sptSplashLeft._TRT_CANCEL = transition.to(sptSplashLeft, {xScale=1, yScale=1, time=600, transition=easing.outElastic})
                end
            end})
        end
    end
    gamemode.onHitScreenParticle = _onHitScreenParticle


    _doGameOver = function()
        if not isGameOver then
            system.deactivate("multitouch")

            isGameOver = true

            Trt.cancelAll()

            transition.to(grpHud, {alpha=0, time=200})
            transition.to(grpShadow, {alpha=0, time=100})
            transition.to(grpBombShadow, {alpha=0, time=100})

            local options = {
                isModal = true,
                effect = "fade",
                time = 0,
                params = {numScore=numScoreT, tblObjects=tblObjects, numCoinsCollected=numCountCoinsCollected}
            }
            Composer.showOverlay("classes.superpop.controller.gamemodes.BombResults", options)
        end
    end
    gamemode.doGameOver = _doGameOver


    _doPreGameOver = function()
        if not isPreGameOver then
            isPreGameOver = true

            transition.pause()

            Runtime:removeEventListener("system", _onSuspendResume)

            if _CHANNEL_BURN ~= nil and tonumber(_CHANNEL_BURN) and _CHANNEL_BURN > 0 then
                audio.stop(_CHANNEL_BURN)
                _CHANNEL_BURN = nil
            end

            if isContinue or numScoreT < _NUM_SCORE_MIN_TO_CONTINUE then --isContinue
                _doGameOver()
            else
                continue = Continue:new({grpView=gamemode})
                if continue == nil then
                    _doGameOver()
                end
            end
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
        isGamingOver = false
        isGameOver = false
        isContinue = true

        rctBg.alpha = 1

        Runtime:addEventListener("system", _onSuspendResume)

        -- RESET SPLASHES
        numCountSplashLeft = 0
        local sptSplashLeft
        for i=1, 3 do
            sptSplashLeft = grpSplashLeft[i]
            sptSplashLeft:setSequence("s")
        end

        transition.resume()

        transition.to(rctBg, {alpha=.01, delay=200, time=300, onComplete=function()
            if scenario and scenario.pauseAll then
                _activateObjects(true)
                scenario:pauseAll(false)
                Trt.resumeAll()

                for i=#tblObjects, 1, -1 do
                    gamemode:removeObject(tblObjects[i])
                end
                Particle.count = 0
            end
        end})

        for i=#tblObjects, 1, -1 do
            tblObjects[i]:hide(true)
        end
        
        Jukebox:dispatchEvent({name="playMusic", id=1, status=1})
    end


    btnPauseEvent = function(event)
        if "ended" == event.phase and Controller:validateNextStatus(2) and btnPause and btnPause.xScale == 1 and not isGamingOver and not isPreGameOver and not isGameOver then
            local options = {
                isModal = true,
                effect = "fade",
                time = 0,
            }
            Composer.showOverlay("classes.superpop.controller.gamemodes.BombPause", options)
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