local Composer = require "composer"


local random = math.random


local Controller = require "classes.superpop.business.Controller"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local _TBL_GIFTS = Constants.TBL_GIFTS


local Gift = {}


function Gift:getGiftCurrent()
    return _TBL_GIFTS[globals_persistence:get("tGiftCurrent").id]
end


function Gift:new(params)

    local params = params or {}


    local scene = Composer.getScene(Composer.getSceneName("overlay"))
    scene = scene == nil and Composer.getScene(Composer.getSceneName("current")) or scene
	local grpView = params.grpView or scene.view


    local gift = display.newGroup()


    if grpView and grpView.insert then


    	grpView:insert(gift)


        local nAddCoins = params.numAddCoins


        -- VERIFY IF IS A AUTOMATIC GIFT
        if nAddCoins == nil then
            local tblGiftCurrent = globals_persistence:get("tGiftCurrent")
            
            nAddCoins = _TBL_GIFTS[tblGiftCurrent.id][2]
            tblGiftCurrent.id = tblGiftCurrent.id < #_TBL_GIFTS and tblGiftCurrent.id + 1 or tblGiftCurrent.id
            tblGiftCurrent.dActivate = os.time() + _TBL_GIFTS[tblGiftCurrent.id][1]
            
            globals_persistence:set("tGiftCurrent", tblGiftCurrent)   
        end


        globals_persistence:addCoins(nAddCoins)   


    	local _onTouchOverlay = function(event)
    		return true
    	end
        local rctOverlay = display.newRect(gift, -10, -10, 350, 500)
        rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
        rctOverlay.alpha = .01
        rctOverlay:setFillColor(0, .9)
        rctOverlay.touch = _onTouchOverlay
        rctOverlay:addEventListener("touch", rctOverlay)
        transition.to(rctOverlay, {alpha=1, time=200})


        local grpBoxCover = display.newGroup()

        local sptBox = display.newSprite(_SHT_UTIL, { {name="standard", frames={258} } })
        sptBox.y = 7
        grpBoxCover:insert(sptBox)

        local sptCover = display.newSprite(_SHT_UTIL, { {name="standard", frames={259} } })
        sptCover.y = -7
        grpBoxCover:insert(sptCover)

        grpBoxCover.anchorX, grpBoxCover.anchorY = .5, .5
        grpBoxCover.x, grpBoxCover.y = display.contentCenterX, display.contentCenterY
        grpBoxCover.xScale, grpBoxCover.yScale = .001, .001
        gift:insert(grpBoxCover)
        transition.to(grpBoxCover, {xScale=1, yScale=1, time=400, transition=easing.outElastic})


        local openBox = function()
            grpBoxCover.rotation = 0
            transition.to(sptCover, {y=sptCover.y - 60, time=500, transition=easing.outElastic, onComplete=function()
                transition.to(sptCover, {alpha=0, delay=250, time=500})
            end})
            transition.to(sptBox, {y=sptBox.y + 60, time=500, transition=easing.outElastic, onComplete=function()
                transition.to(sptBox, {alpha=0, delay=250, time=500})
            end})

            local numMaxTime = 0
            for i=1, 20 do
                local sptCoin = display.newSprite(_SHT_UTIL, { {name="s", start=92, count=1} })
                sptCoin.x, sptCoin.y = display.contentCenterX, display.contentCenterY
                gift:insert(sptCoin)
                local xTo = random(2) == 1 and random(Constants.LEFT, display.contentCenterX - 50) or random(display.contentCenterX + 50, Constants.RIGHT)
                local yTo = random(2) == 1 and  random(Constants.TOP, display.contentCenterY - 40) or random(display.contentCenterY + 40, Constants.BOTTOM)
                local numDelay = 0
                local numTime = i * 30 + 600
                numMaxTime = numMaxTime < (numTime + numDelay) and (numTime + numDelay) or numMaxTime
                transition.to(sptCoin, {x=xTo, y=yTo, time=numTime, delay=numDelay, transition=easing.outExpo, onComplete=function()
                    transition.to(sptCoin, {xScale=.001, yScale=.001, time=800, transition=easing.inElastic, onComplete=function()
                        Jukebox:dispatchEvent({name="playSound", id="coinLow"})
                        if sptCoin and sptCoin.parent and sptCoin.parent.remove then
                            sptCoin.parent:remove(sptCoin)
                        end
                        sptCoin = nil
                    end})
                end})
            end
            numMaxTime = numMaxTime + 1500


            local grpCoinsCollected = display.newGroup()
            gift:insert(grpCoinsCollected)    

            local grpTxtCoinsCollected = display.newGroup()
            grpCoinsCollected:insert(grpTxtCoinsCollected)

            local tblTxtOptions = {
                parent = grpTxtCoinsCollected,
                text = "+"..nAddCoins,
                font = Constants.TBL_STYLE.FAMILY,
                fontSize = 60,
                align = "left"
            }

            local txtCoinsCollected = display.newText(tblTxtOptions)
            txtCoinsCollected:setFillColor(Constants.TBL_STYLE.COLOR_COINS[1], Constants.TBL_STYLE.COLOR_COINS[2], Constants.TBL_STYLE.COLOR_COINS[3], Constants.TBL_STYLE.COLOR_COINS[4])
            txtCoinsCollected.anchorX, txtCoinsCollected.anchorY = 0, .5
            txtCoinsCollected.x, txtCoinsCollected.y = 0, 0

            grpCoinsCollected.anchorChildren = true
            grpCoinsCollected.anchorX, grpCoinsCollected.anchorY = .5, .5
            grpCoinsCollected.x, grpCoinsCollected.y = display.contentCenterX, display.contentCenterY
            grpCoinsCollected:scale(.001, .001)
            transition.to(grpCoinsCollected, {xScale=1, yScale=1, time=600, transition=easing.outElastic})


            transition.to(gift, {alpha=0, delay=numMaxTime, time=300, onComplete=function()
                local scene = Composer.getScene(Composer.getSceneName("overlay"))
                if scene and scene.updateCoins then
                    Jukebox:dispatchEvent({name="playSound", id="coinLow"})

                    scene:updateCoins({numCoinsCollected=nAddCoins})

                    if grpView and grpView.remove then
                        grpView:remove(gift)
                    end
                    gift = nil
                end
            end})

            Jukebox:dispatchEvent({name="playSound", id="collect"})

        end


        local doShake = function() end
        local numRotation = 5
        local numDirection = 1
        doShake = function ()
            numDirection = numDirection * - 1
            numRotation = numRotation + 1.25

            if numRotation > 25 then
                openBox()
            else
                transition.to(grpBoxCover, {time=100 - numRotation * 2, rotation=numRotation * numDirection, onComplete=doShake})
            end
        end
        doShake()
        Jukebox:dispatchEvent({name="playSound", id="collecting"})

    end


	return gift
end


return Gift