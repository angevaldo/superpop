local Trt = require "lib.Trt"


local Controller = require "classes.superpop.business.Controller"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"
local Vector2D = require "lib.Vector2D"


local random = math.random
local ceil = math.ceil


local Bomb = {}

local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())

local _TBL_FRAMES_NORMAL = {
    {241,242,243,244,245,246},
    {235,236,237,238,239,240},
}
local _TBL_FRAMES_INVERTED = {}
for i=1, #_TBL_FRAMES_NORMAL do
    _TBL_FRAMES_INVERTED[i] = {}
    for j=#_TBL_FRAMES_NORMAL[i], 1, -1 do
        _TBL_FRAMES_INVERTED[i][#_TBL_FRAMES_INVERTED[i]+1] = _TBL_FRAMES_NORMAL[i][j]
    end
end

local _activate = function(self, isAtivate)
    local grpBomb = self[1]
    self.isAtivate = isAtivate
    if grpBomb then
        if isAtivate then
            grpBomb:addEventListener("touch", grpBomb)
        else
            grpBomb:removeEventListener("touch")
        end
    end
end

local _pause = function(self, isPause)
    if self[1] and self[1][1] then
        if isPause then
            self[1][1]:pause()
        else    
            self[1][1]:play()
        end
    end
end

local _hide = function(self, isHide)
    self.isVisible = not isHide
    self:pause(isHide)
    if self._CANCEL_SCALE ~= nil then
        if isHide then
            Trt.pause(self._CANCEL_SCALE)
        else
            Trt.resume(self._CANCEL_SCALE)
        end
    end
end

local _onTouch = function(self, event)
    if self.parent and self.parent.isAtivate then
        local bomb = self.parent
        bomb:activate(false)
        if bomb._CANCEL_SCALE ~= nil then
            Trt.cancel(bomb._CANCEL_SCALE)
            bomb._CANCEL_SCALE = nil
        end

        bomb.parent:onExplodedBomb({id=bomb.id, x=bomb.x, y=bomb.y})
    end

    return false
end

function Bomb:new(params)
    -- INIT
    local tbl = {}
    if params ~= nil then tbl = params end


    local numDir = random(2) == 1 and -1 or 1
    local tblFrames = numDir == 1 and _TBL_FRAMES_NORMAL or _TBL_FRAMES_INVERTED
    local numRot = Vector2D:Vec2deg(Vector2D:new(tbl.numToX - tbl.numFromX, tbl.numToY - tbl.numFromX)) - 90 --random(-20, 20)


    local bomb = display.newGroup()


    local grpBomb = display.newGroup()
    bomb:insert(grpBomb)


    local sptMain = display.newSprite(_SHT_UTIL, { {name="s", frames=tblFrames[2], time=600, loopCount=0} })
    sptMain:play()
    grpBomb:insert(sptMain)


    bomb.anchorX, bomb.anchorY = .5, .5
    bomb.x, bomb.y = tbl.numFromX, tbl.numFromY
    bomb.xScale, bomb.yScale, bomb.alpha, bomb.rotation = .1, .1, 1, numRot
    bomb.xFrom, bomb.yFrom = tbl.numFromX, tbl.numFromY
    bomb.isBoing = tbl.isBoing
    bomb.type = 2


    -- ANIM DIRECTION
    bomb._CANCEL_SCALE = Trt.to(bomb, {x=tbl.numToX, y=tbl.numToY, xScale=1.7, yScale=1.7, time=tbl.numTimeOnScreen, onComplete=function(self)
        if bomb.parent and bomb.parent.onHitScreenBomb then
            if bomb.isBoing then
                Jukebox:dispatchEvent({name="playSound", id="boing"})
            end
            bomb.parent:onHitScreenBomb({bomb=bomb})
        end
    end})


    -- EVENTS
    grpBomb.touch = _onTouch
    bomb.activate = _activate
    bomb.pause = _pause
    bomb.hide = _hide


    -- PROPERTIES
    bomb.id = 0
    bomb.numToX = tbl.numToX
    bomb.numToY = tbl.numToY

    return bomb
end

return Bomb