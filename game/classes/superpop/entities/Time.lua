local Trt = require "lib.Trt"


local Jukebox = require "classes.superpop.business.Jukebox"


local random = math.random


local Time = {}
Time.count = 0

local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())

local _activate = function(self, isAtivate)
    local grpTime = self[1]
    self.isAtivate = isAtivate
    if grpTime then
        if isAtivate then
            grpTime:addEventListener("touch", grpTime)
        else    
            grpTime:removeEventListener("touch")
        end
    end
end

local _pause = function(self, isPause)
end

local _hide = function(self, isHide)
    self.isVisible = not isHide
    if self._CANCEL_SCALE ~= nil then
        if isHide then
            Time.count = Time.count - 1
            Trt.pause(self._CANCEL_SCALE)
        else
            Time.count = Time.count + 1
            Trt.resume(self._CANCEL_SCALE)
        end
    end
end

local _onTouch = function(self, event)
    if self.parent and self.parent.isAtivate then

        Time.count = Time.count - 1

        local time = self.parent
        time:activate(false)
        if time._CANCEL_SCALE ~= nil then
            Trt.cancel(time._CANCEL_SCALE)
            time._CANCEL_SCALE = nil
        end
        if self._CANCEL_ROTATION ~= nil then
            Trt.cancel(self._CANCEL_ROTATION)
            self._CANCEL_ROTATION = nil
        end

        self.xScale, self.yScale = 1, 1

        time.parent:onExplodedTimer({object=time})

        local strId = "pop"..random(1, 5)
        Jukebox:dispatchEvent({name="playSound", id=strId})
    end

    return false
end


function Time:new(params)

    local numDir = random(2) == 1 and -1 or 1
    local numRot = random(360) * numDir
    local numRotTo = random(4, 7) * 100 * numDir

    -- INIT
    local tbl = {}
    if params ~= nil then tbl = params end


    local time = display.newGroup()


    local grpTime = display.newGroup()
    time:insert(grpTime)


    local sptMain = display.newSprite(_SHT_UTIL, { {name="s", start=242, count=8, time=400} })
    sptMain:play()
    grpTime:insert(sptMain)


    time.anchorX, time.anchorY = .5, .5
    time.x, time.y = tbl.numFromX, tbl.numFromY
    time.type = 3
    time.xScale, time.yScale, time.alpha, time.rotation = .1, .1, 1, numRot


    -- ANIM ROTATION
    grpTime._CANCEL_ROTATION = Trt.to(grpTime, {rotation=numRotTo, time=tbl.numTimeOnScreen})

    -- ANIM DIRECTION
    time._CANCEL_SCALE = Trt.to(time, {x=tbl.numToX, y=tbl.numToY, xScale=1.7, yScale=1.7, alpha=1, time=tbl.numTimeOnScreen, onComplete=function(self)
        if time.parent and time.parent.onHitScreenTimer then
            Time.count = Time.count - 1
            time.parent:onHitScreenTimer({object=time})
        end
    end})


    -- EVENTS
    grpTime.touch = _onTouch
    time.activate = _activate
    time.pause = _pause
    time.hide = _hide


    -- PROPERTIES
    time.id = 0
    time.numToX = tbl.numToX
    time.numToY = tbl.numToY


    Time.count = Time.count + 1


    return time
end

return Time