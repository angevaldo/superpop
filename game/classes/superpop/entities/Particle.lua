local Trt = require "lib.Trt"


local Controller = require "classes.superpop.business.Controller"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"


local random = math.random
local ceil = math.ceil


local Particle = {}

Particle.count = 0

local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())
local _TBL_FRAMES_EXPLOSION = { {7, 25}, {32, 20} }
local _TBL_FRAMES_EXPLOSION_SCALE = {1,.9,.6,.9,.9}

-- THEMES CONFIGS
local _TBL_DETAIL = {
    -- color(r,g,b)
    { -- DAY
        {0,102/255,204/255},
        {0,150/255,0},
        {102/255,102/255,153/255},
        {230/255,0,0},
        {252/255,204/255,50/255},
    },
    { -- SUNSET
        {0,102/255,204/255},
        {0,150/255,0},
        {102/255,102/255,153/255},
        {230/255,0,0},
        {252/255,204/255,50/255},
    },
    { -- NIGHT
        {0,102/255,204/255},
        {0,150/255,0},
        {102/255,102/255,153/255},
        {230/255,0,0},
        {252/255,204/255,50/255},
    },
    { -- CHRISTMAS
        {255/255,255/255,255/255},
        {200/255,200/255,200/255},
        {255/255,0/255,0/255},
        {53/255,149/255,151/255},
        {245/255,143/255,126/255},
    },
    { -- FITNESS
        {221/255,55/255,41/255},
        {0/255,185/255,66/255},
        {255/255,102/255,153/255},
        {255/255,207/255,0/255},
        {150/255,150/255,150/255},
    },
    { -- STARS
        {164/255,60/255,27/255},
        {128/255,159/255,73/255},
        {214/255,195/255,181/255},
        {249/255,176/255,41/255},
        {255/255,255/255,255/255},
    },
    { -- BEACH
        {251/255,195/255,40/255},
        {71/255,193/255,192/255},
        {121/255,204/255,66/255},
        {241/255,69/255,130/255},
        {113/255,189/255,152/255},
    },
}
Particle.TBL_DETAIL = _TBL_DETAIL

local _onSpriteParticle = function(self, event)
    if event.phase == "ended" and self.parent and self.parent.parent and self.parent.parent.parent then
        local particle = self.parent.parent
        local grp = self.parent.parent.parent
        grp:removeObject(particle)
    end
end

local _onSpriteSpecial = function(self, event)
    if event.phase == "ended" then
        self.rotation = random(360)
        self.xScale, self.yScale = random(2) == 1 and 1 or -1,  random(2) == 1 and 1 or -1
        self:play()
    end
end

local _activate = function(self, isAtivate)
    local grpParticle = self[1]
    self.isAtivate = isAtivate
    if grpParticle then
        if isAtivate then
            self:breath()
            grpParticle:addEventListener("touch", grpParticle)
        else    
            grpParticle:removeEventListener("touch")
        end
    end
end

local _pause = function(self, isPause)
    if self[1] then
        if isPause then
            self[1][1]:pause()
            if self[1][2] then
                self[1][2]:pause()
                self[1][3]:pause()
            end
        else    
            self[1][1]:play()
            if self[1][2] then
                self[1][2]:play()
                self[1][3]:play()
            end
        end
    end
end

local _hide = function(self, isHide)
    self.isVisible = not isHide
    if self._CANCEL_SCALE ~= nil then
        if isHide then
            Particle.count = Particle.count - 1
            Trt.pause(self._CANCEL_SCALE)
        else
            Particle.count = Particle.count + 1
            Trt.resume(self._CANCEL_SCALE)
        end
    end
end

local _onTouch = function(self, event)
    if self.parent and self.parent.isAtivate then

        Particle.count = Particle.count - 1

        local particle = self.parent
        particle:activate(false)
        if particle._CANCEL_SCALE ~= nil then
            Trt.cancel(particle._CANCEL_SCALE)
            particle._CANCEL_SCALE = nil
        end
        if self._CANCEL_BREATH ~= nil then
            Trt.cancel(self._CANCEL_BREATH)
            self._CANCEL_BREATH = nil
        end
        if self._CANCEL_ROTATION ~= nil then
            Trt.cancel(self._CANCEL_ROTATION)
            self._CANCEL_ROTATION = nil
        end

        self.xScale, self.yScale = 1, 1

        local sptMain = self[1]
        sptMain:setSequence("e")
        sptMain:setFillColor(particle.tblColor[1], particle.tblColor[2], particle.tblColor[3])
        if random(2) == 1 then
            sptMain.xScale = -1.6 * particle.numScale
        else
            sptMain.xScale = 1.6 * particle.numScale
        end
        if random(2) == 1 then
            sptMain.yScale = -1.6 * particle.numScale
        else
            sptMain.yScale = 1.6 * particle.numScale
        end
        sptMain:play()
        sptMain:addEventListener("sprite", sptMain)

        particle.parent:onExplodedParticle({id=particle.id, x=particle.x, y=particle.y, isSpecial=particle.isSpecial})

        local strId = "pop"..random(1, 5)
        Jukebox:dispatchEvent({name="playSound", id=strId})
    end

    return false
end

local _breath = function() end
_breath = function(self)
    local grpParticle = self[1]
    grpParticle._CANCEL_BREATH = Trt.to(grpParticle, {time=100, xScale=.85, yScale=1, onComplete=function()
        grpParticle._CANCEL_BREATH = Trt.to(grpParticle, {time=100, xScale=1, yScale=.85, onComplete=function()
            if self.isAtivate and self.breath then
                self:breath()
            end
        end})
    end})
end

function Particle:new(params)

    local _NUM_THEME_CURRENT = globals_persistence:get("nThemeCurrent")
    local _SHT_THEME_CURRENT = Controller:getSheet()

    local numParticleId = random(5)
    local tblColor = _TBL_DETAIL[_NUM_THEME_CURRENT][numParticleId]
    local numDir = random(2) == 1 and -1 or 1
    local numFrameBottom = 51 + numParticleId
    local numRot = random(360) * numDir
    local numRotTo = random(4, 7) * 100 * numDir

    -- INIT
    local tbl = {}
    if params ~= nil then tbl = params end


    local particle = display.newGroup()


    local grpParticle = display.newGroup()
    grpParticle.numParticleId = numParticleId
    particle:insert(grpParticle)


    local i = random(2)
    local sptMain = display.newSprite(_SHT_THEME_CURRENT, {
        {name="s", start=numFrameBottom, count=1},
        {name="e", start=_TBL_FRAMES_EXPLOSION[i][1], count=_TBL_FRAMES_EXPLOSION[i][2], time=500 + 100 * i, loopCount=1},
    })
    sptMain.sprite = _onSpriteParticle
    grpParticle:insert(sptMain)


    if tbl.isSpecial then
        for i=1, 2 do
            local spriteSpecial = display.newSprite(_SHT_UTIL, {
                {name="s", start=22, count=17, time=random(3,6)*100, loopCount=1}
            })
            spriteSpecial:play()
            spriteSpecial.rotation = random(360)
            spriteSpecial.sprite = _onSpriteSpecial
            spriteSpecial:addEventListener("sprite", spriteSpecial)
            grpParticle:insert(spriteSpecial)
        end
    end


    particle.anchorX, particle.anchorY = .5, .5
    particle.x, particle.y = tbl.numFromX, tbl.numFromY
    particle.type = 1
    particle.xScale, particle.yScale, particle.alpha, particle.rotation = .1, .1, 1, numRot


    -- ANIM ROTATION
    grpParticle._CANCEL_ROTATION = Trt.to(grpParticle, {rotation=numRotTo, time=tbl.numTimeOnScreen})

    -- ANIM DIRECTION
    particle._CANCEL_SCALE = Trt.to(particle, {x=tbl.numToX, y=tbl.numToY, xScale=1.7, yScale=1.7, alpha=1, time=tbl.numTimeOnScreen, onComplete=function(self)
        if particle.parent and particle.parent.onHitScreenParticle then
            Particle.count = Particle.count - 1
            particle.parent:onHitScreenParticle({particle=particle})
        end
    end})


    -- EVENTS
    grpParticle.touch = _onTouch
    particle.activate = _activate
    particle.pause = _pause
    particle.breath = _breath
    particle.hide = _hide


    -- PROPERTIES
    particle._NUM_THEME_CURRENT = _NUM_THEME_CURRENT
    particle.id = 0
    particle.numToX = tbl.numToX
    particle.numToY = tbl.numToY
    particle.numScale = _TBL_FRAMES_EXPLOSION_SCALE[numParticleId]
    particle.isSpecial = tbl.isSpecial
    particle.tblColor = tblColor


    Particle.count = Particle.count + 1


    return particle
end

return Particle