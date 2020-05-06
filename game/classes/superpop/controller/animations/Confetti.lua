local Composer = require "composer"


local random = math.random


local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"
local Vector2D = require "lib.Vector2D"


local Confetti = {}


local TBL_COLORS = {
	{ {1,.9,.3},{1,.9,.2},{1,.9,.1},{.9,.8,.1},{.8,.7,0},{.7,.6,0},{.6,.5,0},{1,1,.4} },
	{ {1,0,0},{.9,0,0},{.8,0,0},{.7,0,0},{.6,0,0},{.9,.9,.9},{1,1,1},{.5,.5,.5},{.7,.7,.7} }
}


local function _doAnime(self)
	if self and self.yScale then
		transition.to(self, {yScale=-self.yScale ,time=self.numTimeAnime, onComplete=function()
			if self and self.doAnime then
				self:doAnime()
			end
		end})
	end
end


local function _doMove(self)
	if self and self.y then
		local numTime = self.numTimeMove
		numTime = numTime * ((Constants.BOTTOM - self.y)/Constants.BOTTOM)
		local xTo, yTo = self.x + random(-100, 100), Constants.BOTTOM + 15
		transition.to(self, {x=xTo, y=yTo, time=numTime, transition=easing.inSine, onComplete=function()
			if self and self.doMove then
				self.x, self.y = random(Constants.LEFT, Constants.RIGHT), Constants.TOP - 100
				self:doMove()
			end
		end})
	end
end

local function _doLaunch(self)
	local xTo, yTo = random(Constants.LEFT, Constants.RIGHT), random(-Constants.BOTTOM * .75, Constants.TOP + 100)
	local numRotationTo = random(360)
	local numTime = random(600, 900)
	numTime = numTime * ((self.y - yTo)/Constants.BOTTOM)

	local vecDir = Vector2D:new(self.x - xTo, self.y - yTo)
	self.rotation = Vector2D:Vec2deg(vecDir) 

	transition.to(self, {x=xTo, y=yTo, time=numTime, rotation=numRotationTo, transition=easing.outExpo, onComplete=function()
		if self and self.doAnime then
			self:doAnime()
			self:doMove()
		end
	end})
end

local function _newSpot(params)
	local numWidth, numHeight = 10, 8
	local numReduction = random(5, 10) * .1
	numWidth, numHeight = numWidth * numReduction, numHeight * numReduction

	local rct = display.newRect(params.grp, 0, 0, numWidth, numHeight)
	rct.anchorX, rct.anchorY = .5, .5
	rct.x, rct.y = display.contentCenterX, Constants.BOTTOM + 20
	rct.numTimeAnime = random(4,8) * 100
	rct.numTimeMove = 12000 * (1.25 - numReduction * .5)
	rct.doLaunch = _doLaunch
	rct.doAnime = _doAnime
	rct.doMove = _doMove

	if params.isGold then
		local index = random(#TBL_COLORS[1])
		rct:setFillColor(TBL_COLORS[1][index][1], TBL_COLORS[1][index][2], TBL_COLORS[1][index][3])
	else
		local index = random(#TBL_COLORS[2])
		rct:setFillColor(TBL_COLORS[2][index][1], TBL_COLORS[2][index][2], TBL_COLORS[2][index][3])
	end

	transition.to(params.grp, {time=400, onComplete=function()
		if rct and rct.doLaunch then
			rct:doLaunch()
		end
	end})
end


function Confetti:new(params)

    local params = params or {}


    local scene = Composer.getScene(Composer.getSceneName("overlay"))
    scene = scene == nil and Composer.getScene(Composer.getSceneName("current")) or scene
	local grpView = params.grpView or scene.view


    local confetti = display.newGroup()


    if grpView and grpView.insert then

    	grpView:insert(confetti)
    	for i=1, 60 do
    		_newSpot({grp=confetti, isGold=params.isGold})
    	end

    end


	return confetti
end


return Confetti