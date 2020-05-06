local Composer = require "composer"
local Widget = require "widget"


local Controller = require "classes.superpop.business.Controller"
local Constants = require "classes.superpop.business.Constants"
local Jukebox = require "classes.superpop.business.Jukebox"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local RateIt = {}


function RateIt:new(params)

    local params = params or {}


    local scene = Composer.getScene(Composer.getSceneName("overlay"))
    scene = scene == nil and Composer.getScene(Composer.getSceneName("current")) or scene
	local grpView = params.grpView or scene.view


    local rateIt = display.newGroup()


    local btnBackRelease = function(event)
        if event == nil or "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})

            if grpView and grpView.remove then
                grpView:remove(rateIt)
            end
            rateIt = nil

            globals_bntBackRelease = nil
            Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", params)
        end
        return true
    end
    globals_bntBackRelease = btnBackRelease


    if grpView and grpView.insert then


    	grpView:insert(rateIt)


        local NUM_COINS_TO_ADD = Constants.NUM_COINS_REWARDED_TO_RATE_US 


        local _onTouchOverlay = function(event)
            return true
        end
        local rctOverlay = display.newRect(rateIt, -10, -10, 350, 500)
        rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
        rctOverlay:setFillColor(0, .9)
        rctOverlay.touch = _onTouchOverlay
        rctOverlay:addEventListener("touch", rctOverlay)


        local sptLike = display.newSprite(_SHT_UTIL, { {name="standard", frames={257} } })
        rateIt:insert(sptLike)
        sptLike.x, sptLike.y = display.contentCenterX, display.contentCenterY - 95
        sptLike:scale(.001, .001)
        transition.to(sptLike, {xScale=1, yScale=1, delay=0, time=600, transition=easing.outElastic})


        local tblTxtOptions = {
            font = Constants.TBL_STYLE.FAMILY,
            align = "center"
        }

        local grpMsg = display.newGroup()
        rateIt:insert(grpMsg)

        tblTxtOptions.text = Constants.STR_ASK_TO_RATE_US
        tblTxtOptions.fontSize = 14
        local txtMsg = display.newText(tblTxtOptions)
        grpMsg:insert(txtMsg)
        txtMsg:setFillColor(1)
        txtMsg.anchorX, txtMsg.anchorY = 0, .5
        txtMsg.x, txtMsg.y = 0, 0

        tblTxtOptions.text = " +"..NUM_COINS_TO_ADD
        tblTxtOptions.fontSize = 18
        local txtPrice = display.newText(tblTxtOptions)
        grpMsg:insert(txtPrice)
        txtPrice:setFillColor(Constants.TBL_STYLE.COLOR_COINS[1], Constants.TBL_STYLE.COLOR_COINS[2], Constants.TBL_STYLE.COLOR_COINS[3], Constants.TBL_STYLE.COLOR_COINS[4])
        txtPrice.anchorX, txtPrice.anchorY = 0, .5
        txtPrice.x, txtPrice.y = txtMsg.x + txtMsg.width, 0

        local sptCoin = display.newSprite(_SHT_UTIL, { {name="standard", start=92, count=1} })
        grpMsg:insert(sptCoin)
        sptCoin:scale(.6, .6)
        sptCoin.anchorX, sptCoin.anchorY = 0, .5
        sptCoin.x, sptCoin.y = txtPrice.x + txtPrice.width, -1

        grpMsg.anchorChildren = true
        grpMsg.anchorX, grpMsg.anchorY = .5, .5
        grpMsg.x, grpMsg.y = display.contentCenterX, display.contentCenterY - 25


        local function bntYesRelease(event)
            if "ended" == event.phase then
                Jukebox:dispatchEvent({name="playSound", id="button"})

                globals_persistence:set("isBeenRated", true)

                local options = {
                   iOSAppId = Constants.STR_IOS_APP_ID_TO_RATE,
                   supportedAndroidStores = TBL_SUPPORTED_ANDROID_STORES_TO_RATE,
                }
                native.showPopup("rateApp", options)

                local Gift = require "classes.superpop.controller.animations.Gift"
                local gift = Gift:new({grpView=grpView, numAddCoins=NUM_COINS_TO_ADD})

                if grpView and grpView.remove then
                    grpView:remove(rateIt)
                end
                rateIt = nil

                if grpView then
                    transition.to(grpView, {time=3000, onComplete=function()
                        Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", params)
                    end})
                end
            end

            return true
        end
        local bntYes = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 60,
            overFrame = 61,
            onRelease = bntYesRelease
        }
        rateIt:insert(bntYes)
        bntYes.anchorX, bntYes.anchorY = .5, .5
        bntYes.x, bntYes.y = display.contentCenterX, display.contentCenterY + 40
        bntYes:scale(.001, .001)
        transition.to(bntYes, {xScale=1, yScale=1, delay=300, time=600, transition=easing.outElastic})


        local bntNo = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 43,
            overFrame = 44,
            onEvent = globals_bntBackRelease
        }
        rateIt:insert(bntNo)
        bntNo.anchorX, bntNo.anchorY = .5, .5
        bntNo.x, bntNo.y = Constants.LEFT + bntNo.width * .5, Constants.BOTTOM - bntNo.height * .5
        bntNo:scale(.001, .001)
        transition.to(bntNo, {xScale=1, yScale=1, delay=500, time=600, transition=easing.outElastic})    

    end


	return rateIt
end


return RateIt