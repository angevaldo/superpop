local Composer = require "composer"
local Widget = require "widget"


local random = math.random


local Controller = require "classes.superpop.business.Controller"
local Jukebox = require "classes.superpop.business.Jukebox"
local Constants = require "classes.superpop.business.Constants"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


-- 1-FREE COINS GIFT, 2-IN-APP PURCHASE, 3-REWARDED VIDEO AD, 4-CHANGE SCENARIO, 5-BUY OPTIONS
local _TBL_POSSIBILITIES = {1,1,1,2,2,2,3,4,4,5,5}
local _NUM_THEMES = #Constants.TBL_IAP_THEMES

local Banner = {}

local _newBg = function()
    local sptRectBg = display.newRect(0,0, 500,42)
    sptRectBg:setFillColor(0, .4)
    return sptRectBg
end

local _animeBanner = function(grp, delay)
    grp.x, grp.y = display.contentCenterX, Constants.BOTTOM + 60
    transition.to(grp, {y=Constants.BOTTOM - 5, time=500, transition=easing.outExpo, delay=delay or 1000})
end

local _reset = function(params, grp)
    local grpView = params.grpView

    if grpView and grpView.remove then 
        grpView:remove(grp)
        grp = nil
        Banner:Create(params)
    end
end

local _animeButton = function(btn) end
_animeButton = function(btn)
    if btn and btn.xScale then
        if btn._TRT_CANCEL ~= nil then
            transition.cancel(btn._TRT_CANCEL)
            btn._TRT_CANCEL = nil
        end
        btn._TRT_CANCEL = transition.to(btn, {xScale=.8, yScale=.8, time=200, onComplete=function()
            btn._TRT_CANCEL = transition.to(btn, {xScale=1, yScale=1, time=200, onComplete=function()
                _animeButton(btn)
            end})
        end})
    end
end

local _doCounter = function() end
_doCounter = function(txt, btn, spt)
    if txt and txt.text and spt and spt.xScale then
        local tblBannerCurrent = globals_persistence:get("tGiftCurrent")
        local dif = os.difftime(tblBannerCurrent.dActivate, os.time())
        if dif and dif > -1 then
            local hours = math.floor(dif / 3600)
            local minutes = math.floor((dif % 3600) / 60)
            local seconds = math.floor((dif % 3600) % 60)
            if hours > 0 then
                txt.text = string.format("%2d:%02d:%02d", hours, minutes, seconds)
            elseif minutes > 0 then
                txt.text = string.format("%2d:%02d", minutes, seconds)
            else
                txt.text = string.format("%02d", seconds)
            end
            spt.isVisible = false
            if spt._TRT_CANCEL~= nil then
                transition.cancel(spt._TRT_CANCEL)
                spt._TRT_CANCEL = nil
            end
            spt.xScale, spt.yScale = .001, .001
        else
            txt.text = ""
            spt.isVisible = true
            spt._TRT_CANCEL = transition.to(spt, {xScale=1, yScale=1, time=800, transition=easing.outElastic})
            if _animeButton then
                _animeButton(btn)
            end
        end
        transition.to(txt, {time=1000, onComplete=function()
            if _doCounter then
                _doCounter(txt, btn, spt)
            end
        end})
    end
end


local _newGift = function(params)
    if params and params.grpView and params.grpView.insert then

        local Gift = require "classes.superpop.controller.animations.Gift"

        local grpView = params.grpView

        local grpBanner = display.newGroup()
        grpView:insert(grpBanner)

        grpBanner:insert(_newBg())

        local function btnBannerEvent(event)
            if "ended" == event.phase then
                local tblBannerCurrent = globals_persistence:get("tGiftCurrent")
                local dif = os.difftime(tblBannerCurrent.dActivate, os.time())
                if dif and dif < 0 then
                    Jukebox:dispatchEvent({name="playSound", id="button"})

                    local gift = Gift:new(params)

                    local Notifier = require "classes.superpop.business.Notifier"
                    Notifier:schedule(2, {time=Gift:getGiftCurrent()[1]})

                    _reset(params, grpBanner)

                    gift:toFront()
                else
                    Jukebox:dispatchEvent({name="playSound", id="negation"})
                end
            end
        end
        local btnBanner = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 64,
            overFrame = 65,
            onEvent = btnBannerEvent
        }
        btnBanner.x, btnBanner.y = -75, 0
        grpBanner:insert(btnBanner)

        local txtCounter = display.newText(grpBanner, "", 0, 0, Constants.TBL_STYLE.FAMILY, 22)
        txtCounter:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
        txtCounter.anchorX, txtCounter.anchorY = .5, .5

        local txtCoinsBanner = display.newText(grpBanner, "+"..Gift:getGiftCurrent()[2], 0, 0, Constants.TBL_STYLE.FAMILY, 16)
        txtCoinsBanner:setFillColor(Constants.TBL_STYLE.COLOR_COINS[1], Constants.TBL_STYLE.COLOR_COINS[2], Constants.TBL_STYLE.COLOR_COINS[3], Constants.TBL_STYLE.COLOR_COINS[4])
        txtCoinsBanner.anchorX, txtCoinsBanner.anchorY = 1, .5
        txtCoinsBanner.x, txtCoinsBanner.y = 80, 0

        local sptCoinBanner = display.newSprite(_SHT_UTIL, { {name="s", start=92, count=1} })
        sptCoinBanner:scale(.55, .55)
        sptCoinBanner.x, sptCoinBanner.y = txtCoinsBanner.x + sptCoinBanner.width * .5 - 7, 0
        grpBanner:insert(sptCoinBanner)

        local sptRight = display.newSprite(_SHT_UTIL, { {name="standard", frames={88} } })
        sptRight.anchorX, sptRight.anchorY = .5, .5
        sptRight.x, sptRight.y = 0, 0
        sptRight.isVisible = false
        sptRight:scale(.001, .001)
        grpBanner:insert(sptRight)

        _doCounter(txtCounter, btnBanner, sptRight)

        txtCounter.x, txtCounter.y = 0, 0

        _animeBanner(grpBanner)

        grpBanner:toBack()
    end
end


local _newRewardedVideo = function(params)
    if params and params.grpView and params.grpView.insert then

        local grpBanner = display.newGroup()
        grpBanner:insert(_newBg())
        params.grpView:insert(grpBanner)

        local txtCoinsBanner = display.newText(grpBanner, "+"..Constants.NUM_COINS_REWARDED_VIDEO_AD, 0, 0, Constants.TBL_STYLE.FAMILY, 16)
        txtCoinsBanner:setFillColor(Constants.TBL_STYLE.COLOR_COINS[1], Constants.TBL_STYLE.COLOR_COINS[2], Constants.TBL_STYLE.COLOR_COINS[3], Constants.TBL_STYLE.COLOR_COINS[4])
        txtCoinsBanner.anchorX, txtCoinsBanner.anchorY = 1, .5
        txtCoinsBanner.x, txtCoinsBanner.y = 80, 0

        local sptCoinBanner = display.newSprite(_SHT_UTIL, { {name="s", start=92, count=1} })
        sptCoinBanner:scale(.55, .55)
        sptCoinBanner.x, sptCoinBanner.y = txtCoinsBanner.x + sptCoinBanner.width * .5 - 7, 0
        grpBanner:insert(sptCoinBanner)

        local sptRight = display.newSprite(_SHT_UTIL, { {name="standard", frames={88} } })
        sptRight.anchorX, sptRight.anchorY = .5, .5
        sptRight.x, sptRight.y = 0, 0
        grpBanner:insert(sptRight)

        globals_adCallbackListener = function(params)
            phase = params.phase
            if phase == "hidden" then
                local Gift = require "classes.superpop.controller.animations.Gift"
                Gift:new({grpView=params.grpView, numAddCoins=Constants.NUM_COINS_REWARDED_VIDEO_AD})
            end
            if phase == "hidden" or phase == "bug" then
                globals_adCallbackListener = function() end
            end
        end

        local function btnBannerEvent(event)
            if "ended" == event.phase then
                Jukebox:dispatchEvent({name="playSound", id="button"})

                _reset(params, grpBanner)
                
                local AdsGame = require "classes.superpop.business.AdsGame"
                AdsGame:showRewarded()
            end
        end
        local btnBanner = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 66,
            overFrame = 67,
            onEvent = btnBannerEvent
        }
        btnBanner.x, btnBanner.y = -75, 0
        grpBanner:insert(btnBanner)

        _animeBanner(grpBanner, params.delay)

        grpBanner:toBack()
    end
end


local _pickThemeNotBuyed = function()
    local tblThemesNotBuyed = {}

    local isBuyed = false
    for id=1, _NUM_THEMES do
        isBuyed = globals_persistence:get("tThemeBuyed")["t"..string.format("%02d", id)]
        if isBuyed == false then
            tblThemesNotBuyed[#tblThemesNotBuyed+1] = id
        end
    end

    if #tblThemesNotBuyed == 0 then
        return nil
    end

    return tblThemesNotBuyed[random(#tblThemesNotBuyed)]
end


local _pickThemeBuyed = function() end
_pickThemeBuyed = function()
    local tblThemesBuyed = {}

    local isBuyed = false
    for id=1, _NUM_THEMES do
        isBuyed = globals_persistence:get("tThemeBuyed")["t"..string.format("%02d", id)]
        if isBuyed then
            tblThemesBuyed[#tblThemesBuyed+1] = id
        end
    end

    local numThemeId = tblThemesBuyed[random(#tblThemesBuyed)]
    if numThemeId == globals_persistence:get("nThemeCurrent") then
        return _pickThemeBuyed()
    end

    return numThemeId
end


local _newInApp = function(params)
    if params and params.grpView and params.grpView.insert then

        local grpView = params.grpView

        local grpBanner = display.newGroup()
        grpView:insert(grpBanner)

        grpBanner:insert(_newBg())

        local infThemes = require("classes.superpop.sprites.themes")
        local _SHT_THEMES = graphics.newImageSheet("images/themes.png", infThemes:getSheet())

        local sptTheme = display.newSprite(_SHT_THEMES, { {name="standard", frames=Constants.TBL_IAP_THEMES_FRAMES[params.numThemeId]} })
        sptTheme.anchorX, sptTheme.anchorY = .5, .5
        sptTheme.x, sptTheme.y = 75, 0
        sptTheme:scale(.3, .3)
        grpBanner:insert(sptTheme)

        local txtPrice = display.newText(grpBanner, Constants.TBL_IAP_THEMES[params.numThemeId][2], 0, 0, Constants.TBL_STYLE.FAMILY, 20)
        txtPrice:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
        txtPrice.anchorX, txtPrice.anchorY = .5, .5
        txtPrice.x, txtPrice.y = 0, 0

        local function btnPickRelease(event)
            if "ended" == event.phase then
                Jukebox:dispatchEvent({name="playSound", id="button"})

                local strSceneCurrent = Composer.getSceneName("overlay")
                if strSceneCurrent == nil then
                    local options = {
                        isModal = true,
                        effect = "fade",
                        time = 0,
                        params = {numThemeTo=params.numThemeId}
                    }
                    Composer.showOverlay("classes.superpop.controller.scenes.Options", options)
                else
                    Composer.stage.alpha = 0
                    local options = {
                        effect = "fade",
                        time = 0,
                        params = {numThemeTo=params.numThemeId, scene="classes.superpop.controller.scenes.Frontend", sceneOverlay="classes.superpop.controller.scenes.Options"}
                    }
                    Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", options)
                end
            end
            return true
        end
        local btnPick = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 60,
            overFrame = 61,
            onEvent = btnPickRelease
        }
        btnPick.x, btnPick.y = -75, 0
        btnPick:scale(.5, .5)
        grpBanner:insert(btnPick)

        _animeBanner(grpBanner)

        grpBanner:toBack()
    end
end


local _newChangeScenario = function(params)
    if params and params.grpView and params.grpView.insert then

        local numThemeId = _pickThemeBuyed()

        local grpBanner = display.newGroup()
        grpBanner:insert(_newBg())
        params.grpView:insert(grpBanner)

        local infThemes = require("classes.superpop.sprites.themes")
        local _SHT_THEMES = graphics.newImageSheet("images/themes.png", infThemes:getSheet())

        local sptTheme = display.newSprite(_SHT_THEMES, { {name="standard", frames=Constants.TBL_IAP_THEMES_FRAMES[numThemeId]} })
        sptTheme.anchorX, sptTheme.anchorY = .5, .5
        sptTheme.x, sptTheme.y = 75, 0
        sptTheme:scale(.3, .3)
        grpBanner:insert(sptTheme)

        local sptRight = display.newSprite(_SHT_UTIL, { {name="standard", frames={88} } })
        sptRight.anchorX, sptRight.anchorY = .5, .5
        sptRight.x, sptRight.y = 0, 0
        grpBanner:insert(sptRight)

        local grpChange = display.newGroup()
        local sptChange = display.newSprite(_SHT_UTIL, { {name="standard", frames={62} } })
        sptChange.anchorX, sptChange.anchorY = .5, .5
        sptChange.x, sptChange.y = 0, 0
        grpChange:insert(sptChange)
        local function btnChangeRelease(event)
            if "ended" == event.phase then
                Jukebox:dispatchEvent({name="playSound", id="button"})

                sptChange.isVisible = false

                transition.to(event.target, {alpha=0, time=1, onComplete=function()
                    Controller:setTheme(numThemeId)

                    Composer.stage.alpha = 0
                    local options = {
                        effect = "fade",
                        time = 0,
                        params = {scene="classes.superpop.controller.scenes.Frontend"}
                    }
                    Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", options)
                end})
            end
            return true
        end
        local btnChange = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 53,
            overFrame = 54,
            onEvent = btnChangeRelease
        }
        btnChange.anchorX, btnChange.anchorY = .5, .5
        btnChange.x, btnChange.y = 0, 0
        grpChange:insert(btnChange)
        grpChange.anchorX, grpChange.anchorY = .5, .5
        grpChange.x, grpChange.y = -75, 0
        grpChange:scale(.8, .8)
        sptChange:toFront()
        grpBanner:insert(grpChange)

        _animeBanner(grpBanner, params.delay)

        grpBanner:toBack()
    end
end


local _newBuy = function(params)
    if params and params.grpView and params.grpView.insert then

        local grpView = params.grpView

        local numBuyId = params.numBuyId

        local grpBanner = display.newGroup()
        grpView:insert(grpBanner)

        grpBanner:insert(_newBg())

        local sptLogo = display.newSprite(_SHT_UTIL, { {name="s", start=228+numBuyId, count=1} })
        grpBanner:insert(sptLogo)
        sptLogo.anchorX, sptLogo.anchorY = .5, .5
        sptLogo.x, sptLogo.y = 75, 0

        local txtPrice = display.newText(grpBanner, Constants.TBL_IAP_PRODUCTS[numBuyId][2], 0, 0, Constants.TBL_STYLE.FAMILY, 20)
        txtPrice:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
        txtPrice.anchorX, txtPrice.anchorY = .5, .5
        txtPrice.x, txtPrice.y = 0, 0

        local function btnBuyEvent( event )
            if "ended" == event.phase then
                Jukebox:dispatchEvent({name="playSound", id="button"})

                local strSceneCurrent = Composer.getSceneName("overlay")
                if strSceneCurrent == nil then
                    local options = {
                        isModal = true,
                        effect = "fade",
                        time = 0,
                    }
                    Composer.showOverlay("classes.superpop.controller.scenes.Buy", options)
                else
                    Composer.stage.alpha = 0
                    local options = {
                        effect = "fade",
                        time = 0,
                        params = {scene="classes.superpop.controller.scenes.Frontend", sceneOverlay="classes.superpop.controller.scenes.Buy"}
                    }
                    Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", options)
                end
            end
        end
        local btnBuy = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 55,
            overFrame = 56,
            onEvent = btnBuyEvent
        }
        btnBuy.anchorX, btnBuy.anchorY = .5, .5
        btnBuy.x, btnBuy.y = -75, 0
        btnBuy:scale(.8, .8)
        grpBanner:insert(btnBuy)

        _animeBanner(grpBanner)

        grpBanner:toBack()
    end
end


function Banner:Create(params)
    local tblBannerCurrent = globals_persistence:get("tGiftCurrent")
    local dif = os.difftime(tblBannerCurrent.dActivate, os.time())

    if dif and dif < 0 then
        _newGift(params)
    else
        local index = _TBL_POSSIBILITIES[random(#_TBL_POSSIBILITIES)]

        if index == 1 then
            _newGift(params)
        elseif index == 2 then
            local numThemeId = _pickThemeNotBuyed()
            if numThemeId then
                params.numThemeId = numThemeId
                _newInApp(params)
            else
                _newChangeScenario(params)
            end
        elseif index == 3 then
            if params and params.grpView then
                transition.to(params.grpView, {time=1000, onComplete=function()
                    local Ads = require "plugin.applovin"
                    if Ads then
                        params.delay = 0
                        if Ads.isLoaded(true) and _newRewardedVideo then
                            _newRewardedVideo(params)
                        elseif _newChangeScenario then
                            Ads.load(true)
                            _newChangeScenario(params)
                        end
                    end
                end})
            end
        elseif index == 4 then
            _newChangeScenario(params)
        elseif index == 5 then
            local tblBuyId = {}
            if globals_persistence:get("ads") then
                tblBuyId[#tblBuyId + 1] = 1
            end
            local numThemeId = _pickThemeNotBuyed()
            if numThemeId then
                tblBuyId[#tblBuyId + 1] = 2
            end
            if #tblBuyId == 2 then
                tblBuyId[#tblBuyId + 1] = 3
            end
            if #tblBuyId > 0 then
                params.numBuyId = tblBuyId[random(#tblBuyId)]
                _newBuy(params)
            else
                _newChangeScenario(params)
            end
        end            
    end
end


return Banner