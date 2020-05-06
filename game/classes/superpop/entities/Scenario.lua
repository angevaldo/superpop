local Trt = require "lib.Trt"
local Controller = require "classes.superpop.business.Controller"

local Constants = require "classes.superpop.business.Constants"
local Jukebox = require "classes.superpop.business.Jukebox"

local random = math.random

local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local Scenario = {}

local _INDEX_FG = 5
local _INDEX_OBJECTS3 = 4
local _INDEX_OBJECTS2 = 3
local _INDEX_OBJECTS1 = 2
local _INDEX_BG = 1

local _LEFT, _RIGHT, _TOP, _BOTTOM, _CENTERX, _CENTERY = Constants.LEFT, Constants.RIGHT, Constants.TOP, Constants.BOTTOM, display.contentCenterX, display.contentCenterY
local _TBL_ROTATIONS = {-2500, -1440, -720, 720, 1440, 2500}

local _TBL_FRAMES_EYES_1 = {200,200,200,201,202,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,}
local _TBL_FRAMES_EYES_2 = {200,200,200,201,202,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,203,}
local _TBL_FRAMES_EYES_3 = {200,200,200,201,202,203,203,203,203,203,203,203,203,203,}
local _TBL_FRAMES_EYES_4 = {205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,206,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,206,}
local _TBL_FRAMES_EYES_5 = {203,203,202,202,201,201,200,200,200,200,203,203,203,203,203,203,203,203,203,203,203,202,202,201,201,200,200,200,203,203,203,203,202,202,201,201,200,200,200,200,200,200,200,200,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,200,200,201,202,203,}
local _TBL_FRAMES_EYES_6 = {203,202,201,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,201,202,203,203,203,203,203,}

local _TBL_FRAMES_EYES_7 = {205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,206,}
local _TBL_FRAMES_EYES_8 = {207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,206,}

--[[ 
-- READJUST FRAMES ALGORITHM
local ftbl = function(title, tbl)
    for i=1, #tbl do
        tbl[i] = tbl[i] + 20
    end
    local str = title.." = {"
    for i=1, #tbl do
        str = str..tbl[i]..","
    end
    str = str.. "}"
    print(str)
end
ftbl("_TBL_FRAMES_EYES_1", _TBL_FRAMES_EYES_1)
ftbl("_TBL_FRAMES_EYES_2", _TBL_FRAMES_EYES_2)
ftbl("_TBL_FRAMES_EYES_3", _TBL_FRAMES_EYES_3)
ftbl("_TBL_FRAMES_EYES_4", _TBL_FRAMES_EYES_4)
ftbl("_TBL_FRAMES_EYES_5", _TBL_FRAMES_EYES_5)
ftbl("_TBL_FRAMES_EYES_6", _TBL_FRAMES_EYES_6)
ftbl("_TBL_FRAMES_EYES_7", _TBL_FRAMES_EYES_7)
ftbl("_TBL_FRAMES_EYES_8", _TBL_FRAMES_EYES_8)
--]]

local _TBL_FRAMES_EYES_RANDOM_INDEX = {1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,5,5,6}
local _TBL_FRAMES_EYES_BLINK = {
    s1={f3="blink"},
    s2={f3="blink"},
    s3={f3="blink"},
    s4={f3="look",f19="look"},
    s5={f10="blink",f28="blink",f46="snoring",f86="snoring",f126="snoring"},
    s6={f31="blink"},
    s7={f3="look"},
    s8={f3="look"},
}

-- THEMES CONFIGS
local _TBL_THEME_OVERLAY_ALPHA = {
    .3, -- DAY
    .3, -- SUNSET
    .1, -- NIGHT
    .5, -- CHRISTMAS
    .4, -- FITNESS
    .7, -- STARS
    .4, -- BEACH
}
local _TBL_THEME_OBJECTS = {
    { -- DAY
        { layer=_INDEX_OBJECTS1, x=_CENTERX, y=_CENTERY+50, color={1,1,1,1}, start=14, count=2, loopCount=1, scale=1, animated=false }, -- MOUNTAINS
        { layer=_INDEX_OBJECTS2, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start={6,8,10,12}, count=1, loopCount=1, scale={.7,1}, animated=true, timeSprite=5000, timeMove=50000, quantity=3, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS3, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start={6,8,10,12}, count=1, loopCount=1, scale={.7,1}, animated=true, timeSprite=5000, timeMove=60000, quantity=3, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS3, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start=16, count=10, loopCount=0, scale={.5,1}, animated=true, timeSprite=700, timeMove=8000, quantity=3, direction="horizontal" }, -- SEAGULL
        { layer=_INDEX_FG, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=2, count=2, loopCount=1, scale=1, animated=false }, -- GARDEN
        { layer=_INDEX_FG, id="eyes" }, -- EYES
        { layer=_INDEX_FG, x={_CENTERX-100,_CENTERX+100}, y={_CENTERY+200, _CENTERY+230}, color={1,1,1,1}, start=4, count=2, loopCount=1, scale=1, animated=false }, -- OBJECT
    },
    { -- SUNSET
        { layer=_INDEX_OBJECTS1, x=_CENTERX, y=_CENTERY+50, color={1,1,1,1}, start=14, count=2, loopCount=1, scale=1, animated=false }, -- MOUNTAINS
        { layer=_INDEX_OBJECTS2, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start={6,8,10,12}, count=1, loopCount=1, scale={.7,1}, animated=true, timeSprite=5000, timeMove=50000, quantity=3, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS3, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start={6,8,10,12}, count=1, loopCount=1, scale={.7,1}, animated=true, timeSprite=5000, timeMove=60000, quantity=3, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS3, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start=16, count=10, loopCount=0, scale={.5,1}, animated=true, timeSprite=700, timeMove=8000, quantity=2, direction="horizontal" }, -- SEAGULL
        { layer=_INDEX_FG, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=2, count=2, loopCount=1, scale=1, animated=false }, -- GARDEN
        { layer=_INDEX_FG, id="eyes" }, -- EYES
        { layer=_INDEX_FG, x={_CENTERX-100,_CENTERX+100}, y={_CENTERY+200, _CENTERY+230}, color={1,1,1,1}, start=4, count=2, loopCount=1, scale=1, animated=false }, -- OBJECT
    },
    { -- NIGHT
        { layer=_INDEX_OBJECTS1, x={_CENTERX-100,_CENTERX}, y={_CENTERY-150, _CENTERY-100}, color={1,1,1,1}, start=16, count=2, loopCount=1, scale=1, animated=false }, -- STARS
        { layer=_INDEX_OBJECTS1, x={_CENTERX,_CENTERX+100}, y={_CENTERY, _CENTERY+50}, color={1,1,1,1}, start=16, count=2, loopCount=1, scale=1, animated=false }, -- STARS
        { layer=_INDEX_OBJECTS1, x=_CENTERX, y=_CENTERY+50, color={1,1,1,1}, start=14, count=2, loopCount=1, scale=1, animated=false }, -- MOUNTAINS
        { layer=_INDEX_OBJECTS2, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start={6,8,10,12}, count=1, loopCount=1, scale={.7,1}, animated=true, timeSprite=5000, timeMove=50000, quantity=2, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS3, x=0, y={_TOP-20,_CENTERY-20}, color={1,1,1,1}, start={6,8,10,12}, count=1, loopCount=1, scale={.7,1}, animated=true, timeSprite=5000, timeMove=60000, quantity=2, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_FG, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=2, count=2, loopCount=1, scale=1, animated=false }, -- GARDEN
        { layer=_INDEX_FG, id="eyes" }, -- EYES
        { layer=_INDEX_FG, x={_CENTERX-100,_CENTERX+100}, y={_CENTERY+200, _CENTERY+230}, color={1,1,1,1}, start=4, count=2, loopCount=1, scale=1, animated=false }, -- OBJECT
    },
    { -- CHRISTMAS
        { layer=_INDEX_OBJECTS1, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=2, count=2, loopCount=1, scale=1, animated=false }, -- GARDEN
        { layer=_INDEX_OBJECTS2, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=4, count=2, loopCount=1, scale=1, animated=false }, -- GARDEN
        { layer=_INDEX_OBJECTS2, id="eyes" }, -- EYES
        { layer=_INDEX_OBJECTS3, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=6, count=2, loopCount=1, scale=1, animated=false }, -- GARDEN
        { layer=_INDEX_FG, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=8, count=2, loopCount=1, scale=1, animated=false }, -- GARDEN
        { layer=_INDEX_OBJECTS1, x={_LEFT-50,_RIGHT+50}, y=-1, color={1,1,1,1}, start=10, count=1, loopCount=1, scale={.3,.5}, animated=true, timeSprite=5000, timeMove=20000, quantity=10, direction="vertical", variation=50 }, -- SNOW
        { layer=_INDEX_OBJECTS2, x={_LEFT-50,_RIGHT+50}, y=-1, color={1,1,1,1}, start=10, count=1, loopCount=1, scale={.6,.7}, animated=true, timeSprite=5000, timeMove=15000, quantity=10, direction="vertical", variation=100 }, -- SNOW
        { layer=_INDEX_OBJECTS3, x={_LEFT-50,_RIGHT+50}, y=-1, color={1,1,1,1}, start=10, count=1, loopCount=1, scale={.8,.9}, animated=true, timeSprite=5000, timeMove=11000, quantity=10, direction="vertical", variation=200 }, -- SNOW
        { layer=_INDEX_FG, x={_LEFT-50,_RIGHT+50}, y=-1, color={1,1,1,1}, start=10, count=1, loopCount=1, scale=1, animated=true, timeSprite=5000, timeMove=8000, quantity=10, direction="vertical", variation=300 }, -- SNOW
    },
    { -- FITNESS
        { layer=_INDEX_FG, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=2, count=2, loopCount=1, scale=1, animated=false }, -- ROOM
        { layer=_INDEX_FG, id="eyes" }, -- EYES
    },
    { -- STARS
        { layer=_INDEX_OBJECTS1, x=_CENTERX, y=_CENTERY, color={1,1,1,1}, start=2, count=2, loopCount=1, scale=1, animated=false }, -- SPACE
        { layer=_INDEX_OBJECTS2, x=0, y={_TOP-20,_BOTTOM+20}, color={1,1,1,1}, start={6,8,10,12,14,16}, count=1, loopCount=1, scale={.5,.7}, animated=true, timeSprite=5000, timeMove=100000, quantity=3, direction="horizontal" }, -- PLANETS
        { layer=_INDEX_OBJECTS3, x=0, y={_TOP-20,_BOTTOM+20}, color={1,1,1,1}, start={6,8,10,12,14,16}, count=1, loopCount=1, scale={.8,1}, animated=true, timeSprite=5000, timeMove=60000, quantity=2, direction="horizontal" }, -- PLANETS
        { layer=_INDEX_FG, x=_CENTERX-1, y=_CENTERY-12, color={1,1,1,1}, start=4, count=2, loopCount=1, scale=1, animated=false }, -- SHIP
        { layer=_INDEX_FG, id="eyes" }, -- EYES
    },
    { -- BEACH
        { layer=_INDEX_OBJECTS1, x=0, y={_TOP-30,_CENTERY-20}, color={1,1,1,1}, start={6,8,10}, count=1, loopCount=1, scale={.4,.5}, animated=true, timeSprite=5000, timeMove=120000, quantity=3, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS2, x=0, y={_TOP-30,_CENTERY-20}, color={1,1,1,1}, start={6,8,10}, count=1, loopCount=1, scale={.7,.9}, animated=true, timeSprite=5000, timeMove=90000, quantity=3, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS3, x=0, y={_TOP-30,_CENTERY-20}, color={1,1,1,1}, start={6,8,10}, count=1, loopCount=1, scale={.8,1}, animated=true, timeSprite=5000, timeMove=60000, quantity=2, direction="horizontal" }, -- CLOUD
        { layer=_INDEX_OBJECTS3, x=_CENTERX, y=_CENTERY-10, color={1,1,1,1}, start=2, count=2, loopCount=1, scale=1, animated=false }, -- BEACH
        { layer=_INDEX_FG, id="eyes" }, -- EYES
    },
}

local function _moveObject(self)
    local numTimeScale = random(7, 13) * .1
    local numTime = self.timeMove * numTimeScale
    self.timeScale = 2 - numTimeScale

    if self.direction == "horizontal" then
        Trt.to(self, {time=numTime, x=self.xTo, y=self.yTo, rotation=self.rotationTo, onComplete=function()
            if self and self.move then
                local dir = 0
                if self.xFrom == 0 then
                    dir = random(2) == 1 and 1 or -1
                elseif self.xFrom == -1 then
                    dir = 1
                elseif self.xFrom == 1 then
                    dir = -1
                end
                self.y = "table" == type(self.yFrom) and random(self.yFrom[1], self.yFrom[2]) or self.yFrom
                self.yTo = self.y + random(-self.variation, self.variation)
                local numDist = (_CENTERX - _LEFT) * 2
                if dir == 1 then
                    self.x = _CENTERX - numDist
                    self.xTo = _CENTERX + numDist
                    self.xScale = self.xScale < 0 and (self.xScale * -1) or self.xScale
                else
                    self.x = _CENTERX + numDist
                    self.xTo = _CENTERX - numDist
                    self.xScale = self.xScale > 0 and (self.xScale * -1) or self.xScale
                end
                self.rotation = 0
                self:move()
            end
        end})
    else
        Trt.to(self, {time=numTime, y=self.yTo, x=self.xTo, rotation=self.rotationTo, onComplete=function()
            if self and self.move then
                local dir = 0
                if self.yFrom == 0 then
                    dir = random(2) == 1 and 1 or -1
                elseif self.yFrom == -1 then
                    dir = 1
                elseif self.yFrom == 1 then
                    dir = -1
                end
                self.x = "table" == type(self.xFrom) and random(self.xFrom[1], self.xFrom[2]) or self.xFrom
                self.xTo = self.x + random(-self.variation, self.variation)
                local numDist = (_CENTERY - _TOP) * 2
                if dir == 1 then
                    self.y = _CENTERY - numDist
                    self.yTo = _CENTERY + numDist
                    self.yScale = self.yScale < 0 and (self.yScale * -1) or self.yScale
                else
                    self.y = _CENTERY + numDist
                    self.yTo = _CENTERY - numDist
                    self.yScale = self.yScale > 0 and (self.yScale * -1) or self.yScale
                end
                self.rotation = 0
                self:move()
            end
        end})
    end
end

local function _onSpriteEye(self, event)
    local strSoundFrame = _TBL_FRAMES_EYES_BLINK[self.sequence]["f"..self.frame]
    if strSoundFrame then
        Jukebox:dispatchEvent({name="playSound", id=strSoundFrame})
    end
    if event.phase == "ended" and self.setSequence then
        self:setSequence(self.sequenceNext)
        self:play()

        local numSequence = _TBL_FRAMES_EYES_RANDOM_INDEX[random(#_TBL_FRAMES_EYES_RANDOM_INDEX)]
        self.sequenceNext = "s"..numSequence
    end
end

local function _onTouch(self, event)
    if event.phase == "began" then
        local sptEyes = self.sptEyes
        if sptEyes and sptEyes.sequence then
            if event.x < display.contentCenterX then
                sptEyes:setSequence("s8")
            else
                sptEyes:setSequence("s7")
            end
            sptEyes.sequenceNext = "s1"
            sptEyes:play()
        end
    end
    return false
end

local function _create(scenario)

    local _SHT_THEME_CURRENT = Controller:getSheetScenario()

    local sptBg = display.newSprite(_SHT_THEME_CURRENT, { {name="s", start=1, count=1} })
    scenario[_INDEX_BG]:insert(sptBg)
    sptBg.anchorX, sptBg.anchorY = .5, 1
    sptBg.x, sptBg.y  = _CENTERX, _CENTERY + 100
    sptBg.width = 1000
    sptBg.height = 500

    local tblThemeCurrent = _TBL_THEME_OBJECTS[globals_persistence:get("nThemeCurrent")]

    for i=1, #tblThemeCurrent do
        local tblObject = tblThemeCurrent[i]
        local quantity = tblObject.quantity or 1
        local alpha = tblObject.alpha and random(tblObject.alpha[1], tblObject.alpha[2]) * .01 or 1

        for i=1, quantity do

            -- EYES
            if tblObject.id == "eyes" then
                local sptEyes = display.newSprite(_SHT_UTIL, { 
                    {name="s1", frames=_TBL_FRAMES_EYES_1, time=#_TBL_FRAMES_EYES_1*60, loopCount=1},
                    {name="s2", frames=_TBL_FRAMES_EYES_2, time=#_TBL_FRAMES_EYES_2*60, loopCount=1},
                    {name="s3", frames=_TBL_FRAMES_EYES_3, time=#_TBL_FRAMES_EYES_3*60, loopCount=1},
                    {name="s4", frames=_TBL_FRAMES_EYES_4, time=#_TBL_FRAMES_EYES_4*60, loopCount=1},
                    {name="s5", frames=_TBL_FRAMES_EYES_5, time=#_TBL_FRAMES_EYES_5*60, loopCount=1},
                    {name="s6", frames=_TBL_FRAMES_EYES_6, time=#_TBL_FRAMES_EYES_6*60, loopCount=1},
                    {name="s7", frames=_TBL_FRAMES_EYES_7, time=#_TBL_FRAMES_EYES_7*60, loopCount=1},
                    {name="s8", frames=_TBL_FRAMES_EYES_8, time=#_TBL_FRAMES_EYES_8*60, loopCount=1},
                })
                sptEyes.anchorX, sptEyes.anchorY = .5, .5
                sptEyes.x, sptEyes.y = display.contentCenterX, display.contentCenterY - 27
                sptEyes.sequenceNext = "s2"
                sptEyes.sprite = _onSpriteEye
                sptEyes:addEventListener("sprite", sptEyes)
                sptEyes:play()
                scenario.sptEyes = sptEyes
                scenario[tblObject.layer]:insert(sptEyes)
                break
            end

            local numStart = "table" == type(tblObject.start) and tblObject.start[random(1, #tblObject.start)] or tblObject.start
            local numScale = "table" == type(tblObject.scale) and random(tblObject.scale[1]*10, tblObject.scale[2]*10)*.1 or tblObject.scale

            local tblOptions = { {name="s", start=numStart, count=tblObject.count, time=tblObject.timeSprite or 1, loopCount=tblObject.loopCount} }
            if tblObject.animated then
                tblOptions[#tblOptions+1] = {name="b", start=numStart + tblObject.count, count=tblObject.count, time=tblObject.timeSprite or 1,loopCount=tblObject.loopCount}
            end

            local spt = display.newSprite(_SHT_THEME_CURRENT, tblOptions)
            scenario[tblObject.layer]:insert(spt)
            spt.animated = tblObject.animated
            spt.direction = tblObject.direction
            spt.alpha = alpha
            spt.rotationTo = tblObject.rotate and _TBL_ROTATIONS[random(#_TBL_ROTATIONS)] or 0
            spt.anchorX, spt.anchorY = .5, .5
            spt.x = "table" == type(tblObject.x) and random(tblObject.x[1], tblObject.x[2]) or tblObject.x
            spt.y = "table" == type(tblObject.y) and random(tblObject.y[1], tblObject.y[2]) or tblObject.y
            spt.xScale, spt.yScale = numScale, numScale
            spt:setFillColor(tblObject.color[1], tblObject.color[2], tblObject.color[3], tblObject.color[4])

            if tblObject.animated then
                local variation = tblObject.variation or 0
                spt.variation = variation

                if tblObject.direction == "horizontal" then
                    local dir = 0
                    if tblObject.x == 0 then
                        dir = random(2) == 1 and 1 or -1
                    elseif tblObject.x == -1 then
                        dir = 1
                    elseif tblObject.x == 1 then
                        dir = -1
                    end

                    local numDist = (_CENTERX - _LEFT) * 2
                    spt.xFrom = tblObject.x

                    spt.x = random(_CENTERX - numDist, _CENTERX + numDist)
                    spt.yTo = spt.y + random(-variation, variation)
                    spt.yFrom = tblObject.y
                    spt.timeMove = tblObject.timeMove

                    if dir == 1 then
                        spt.xTo = _CENTERX + numDist
                    else
                        spt.xTo = _CENTERX - numDist
                        spt.xScale = spt.xScale * -1
                    end
                else
                    local dir = 0
                    if tblObject.y == 0 then
                        dir = random(2) == 1 and 1 or -1
                    elseif tblObject.y == -1 then
                        dir = 1
                    elseif tblObject.y == 1 then
                        dir = -1
                    end

                    local numDist = (_CENTERY - _TOP) * 2
                    spt.yFrom = tblObject.y

                    spt.y = random(_CENTERY - numDist, _CENTERY + numDist)
                    spt.xTo = spt.x + random(-variation, variation)
                    spt.xFrom = tblObject.x
                    spt.timeMove = tblObject.timeMove

                    if dir == 1 then
                        spt.yTo = _CENTERY + numDist
                    else
                        spt.yTo = _CENTERY - numDist
                        spt.yScale = spt.yScale * -1
                    end
                end
                spt.move = _moveObject

                spt:move()
                spt:play()
            end

        end
    end

end

local function _start(self)
    if self.sptEyes and self.sptEyes.parent then
        self.sptEyes.parent:remove(self.sptEyes)
        self.sptEyes = nil 
    end

    self:removeEventListener("touch", self)
    self[self.numChildren].isVisible = true

    local obj = 0
    for i=2, self.numChildren do
        local grp = self[i]
        for j=1, grp.numChildren do
            obj = grp[j]
            if obj.animated then
                obj:setSequence("b")
            end
            obj:play()
            obj.xScale, obj.yScale = obj.xScale * 4, obj.yScale * 4
        end
    end
end

local function _pauseAll(self, isPause)
    local obj = 0
    local grp = 0

    for i=2, self.numChildren do
        grp = self[i]
        for j=1, grp.numChildren do
            obj = grp[j]
            if obj.animated then
                if isPause then
                    obj:pause()
                else
                    obj:play()
                end
            end
        end
    end
end

local function _timeScaleAll(self, numTimeScale)
    local obj = 0
    local grp = 0

    for i=2, self.numChildren do
        grp = self[i]
        for j=1, grp.numChildren do
            obj = grp[j]
            if obj.animated then
                obj.timeScale = numTimeScale
            end
        end
    end
end

local function _moveAll(self, params)
    local xParam = params.x - display.contentCenterX
    local yParam = params.y - display.contentCenterY
    if self._CANCEL_MOVEMENT ~= nil then 
        Trt.cancel(self._CANCEL_MOVEMENT) 
        self._CANCEL_MOVEMENT = nil 
    end
    self._CANCEL_MOVEMENT = Trt.to(self, {x=xParam, y=yParam, time=params.time, transition=params.transition})
end

function Scenario:new(params)
    -- INIT
    local tbl = {}
    if params ~= nil then tbl = params end

    -- OBJECT
    local scenario = display.newGroup()

    for i=1, _INDEX_FG do
        scenario:insert(display.newGroup())
    end

    local rctOverlay = display.newRect(scenario, 0, 0, 2000, 2000)
    rctOverlay.anchorX, rctOverlay.anchorY = .5, .5
    rctOverlay.x, rctOverlay.y = 0, 0
    rctOverlay.numChildren = 0
    rctOverlay.isVisible = false
    rctOverlay:setFillColor(0, _TBL_THEME_OVERLAY_ALPHA[Controller:getThemeId()])

    -- METHODS
    scenario.start = _start
    scenario.pauseAll = _pauseAll
    scenario.timeScaleAll = _timeScaleAll
    scenario.moveAll = _moveAll

    -- TOUCH ANIMATION REACTION
    scenario.touch = _onTouch
    scenario:addEventListener("touch", scenario)

    -- PROPERTIES

    _create(scenario)

    return scenario
end

return Scenario