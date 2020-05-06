local Composer = require "composer"
local objScene = Composer.newScene()


local Jukebox = require "classes.superpop.business.Jukebox"
local Controller = require "classes.superpop.business.Controller"
local Constants = require "classes.superpop.business.Constants"
local Util = require "classes.superpop.business.Util"


local Toast = require "plugin.toast"
local Widget = require "widget"
local Store = require "store" 
if system.getInfo("platformName") == "Android" then
    Store = require "plugin.google.iap.v3" 
end


local abs = math.abs
local scvThemes
local btnBuy
local btnSelect
local txtPrice


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())
local infThemes = require("classes.superpop.sprites.themes")
local _SHT_THEMES = graphics.newImageSheet("images/themes.png", infThemes:getSheet())


local _TBL_IAP_THEMES_FRAMES = Constants.TBL_IAP_THEMES_FRAMES
local _TBL_IAP_THEMES = Constants.TBL_IAP_THEMES
local _TBL_IAP_PRODUCTS = Constants.TBL_IAP_PRODUCTS

local _NUM_THEME_COINS_PRICE = 1000
local _NUM_ICON_SCALE_MIN = .5
local _NUM_BUTTON_DIST = 100
local _NUM_THEME_SELECTED = globals_persistence:get("nThemeCurrent")


local btnBackRelease = function(event)
    if event == nil or "ended" == event.phase then
        Jukebox:dispatchEvent({name="playSound", id="button"})

        Controller:hideOverlay(200)
    end
    return true
end


local _showLoader = function(isHide)
    if not Store.isActive or (not Store.canMakePurchases and Store.target == "apple") then
        --native.showAlert(" ", "Store inactive", {"OK"})
        Toast.show("Store inactive", {duration="long"})
    else
        native.setActivityIndicator(isHide)
    end
end


local _updateButtons = function(numId, isBuyed)
    if isBuyed then
        btnSelect.isVisible = true
        btnBuy.isVisible = false
        txtPrice.isVisible = false
    else
        btnSelect.isVisible = false
        btnBuy.isVisible = true
        txtPrice.isVisible = true
        txtPrice.text = _TBL_IAP_THEMES[numId][2]
    end
end


local _moveScrollTo = function(numId)
    if scvThemes and scvThemes.scrollToPosition then
        local grp = (scvThemes.getView and scvThemes:getView()[1]) and scvThemes:getView()[1] or nil
        if grp and grp.numChildren >= numId then
            local isPlaySound = grp[numId].xSelectedPosition ~= grp.parent.x
            scvThemes:scrollToPosition({x=grp[numId].xSelectedPosition, time=100, onComplete=function()
                if isPlaySound then
                    Jukebox:dispatchEvent({name="playSound", id="selected"})
                end
                local isBuyed = globals_persistence:get("tThemeBuyed")["t"..string.format("%02d", numId)]
                _updateButtons(numId, isBuyed)

                local icon = 0
                local numChildren = grp.numChildren
                for i=1,numChildren do
                    icon = grp[i]
                    if icon._TRT_CANCEL ~= nil then
                        transition.cancel(icon._TRT_CANCEL)
                        icon._TRT_CANCEL = nil
                    end
                    if i == numId then
                        icon._TRT_CANCEL = transition.to(icon, {xScale=1, yScale=1, time=400, transition=easing.outElastic})
                    elseif icon.xScale ~= _NUM_ICON_SCALE_MIN then
                        icon._TRT_CANCEL = transition.to(icon, {xScale=_NUM_ICON_SCALE_MIN, yScale=_NUM_ICON_SCALE_MIN, time=200})
                    end
                end
            end})
        end
    end
end


function objScene:create(event)
    local grpView = self.view


    self.params = event.params


    globals_btnBackRelease = btnBackRelease


    local rctOverlay = display.newRect(grpView, -10, -10, 350, 500)
    rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
    rctOverlay:setFillColor(0, .9)


    local grpHelp = display.newGroup()
    grpView:insert(grpHelp)

    local sptLeft = display.newSprite(_SHT_UTIL, { {name="standard", frames={88} } })
    sptLeft.anchorX, sptLeft.anchorY = 0, 1
    sptLeft.x, sptLeft.y = -20, 5
    sptLeft:scale(.6, .6)
    sptLeft.rotation = 180
    grpHelp:insert(sptLeft)

    local sptRight = display.newSprite(_SHT_UTIL, { {name="standard", frames={88} } })
    sptRight.anchorX, sptRight.anchorY = 0, 0
    sptRight.x, sptRight.y = 20, 5
    sptRight:scale(.6, .6)
    grpHelp:insert(sptRight)

    local sptHand = display.newSprite(_SHT_UTIL, { {name="standard", frames={89} } })
    sptHand.anchorX, sptHand.anchorY = .5, 0
    sptHand.x, sptHand.y = 0, 0
    grpHelp:insert(sptHand)

    grpHelp.anchorX, grpHelp.anchorY = .5, .5
    grpHelp.x, grpHelp.y = display.contentCenterX, display.contentCenterY - 140
    grpHelp.alpha = 0
    transition.to(grpHelp, {time=300, alpha=1, delay=1000})

    local x1 = sptHand.x + 10
    local x2 = sptHand.x - 10
    sptHand.x = x1
    local _moveHand = function() end
    _moveHand = function()
        if sptHand and sptHand.x then
            local xTo = sptHand.x == x1 and x2 or x1
            transition.to(sptHand, {x=xTo, time=500, delay=200, onComplete=function()
                _moveHand()
            end})
        end
    end
    _moveHand()
    local _hideHand = function()
        if grpHelp then
            transition.to(grpHelp, {time=600, alpha=0, onComplete=function()
                if grpView and grpView.remove then
                    grpView:remove(grpHelp)
                    grpHelp = nil
                end
            end})
        end
    end


    local NUM_THEME_CURRENT = _NUM_THEME_SELECTED


    local function scvThemesListener(event)
        local grp = (event.target and event.target.getView and event.target:getView()[1]) and event.target:getView()[1] or nil
        if grp then
            local phase = event.phase
            local icon = 0
            local numScale = 0
            local numXParent = grp.parent.x
            if phase == "began" then 
                _hideHand()
            elseif phase == "moved" then 
                for i=1,grp.numChildren do
                    icon = grp[i]
                    numScale = 1 - abs(numXParent + icon.x - 200) * .01
                    if numScale < _NUM_ICON_SCALE_MIN then
                        numScale = _NUM_ICON_SCALE_MIN
                    elseif numScale > 1 then
                        numScale = _NUM_ICON_SCALE_MIN
                    end
                    icon.xScale, icon.yScale = numScale, numScale
                end
            elseif phase == "ended" then 
                local numScale = 0
                for i=1,grp.numChildren do
                    icon = grp[i]
                    if icon.xScale > numScale then
                        _NUM_THEME_SELECTED = i
                        numScale = icon.xScale
                    end
                end
                _moveScrollTo(_NUM_THEME_SELECTED)
            end
        end
        return true
    end
    scvThemes = Widget.newScrollView{ friction=0, width=400, height=500, verticalScrollDisabled=true, hideBackground=true, isBounceEnabled=false, listener=scvThemesListener }
    scvThemes.anchorX, scvThemes.anchorY = .5, .5
    scvThemes.x, scvThemes.y = display.contentCenterX, display.contentCenterY
    grpView:insert(scvThemes)


    local sptBG = display.newSprite(_SHT_UTIL, { {name="standard", frames={3} } })
    sptBG.anchorX, sptBG.anchorY = scvThemes.anchorX, scvThemes.anchorY
    sptBG.x, sptBG.y = scvThemes.x, scvThemes.y
    sptBG.alpha = .2
    grpView:insert(sptBG)


    local transactionCallback = function(event) end
    transactionCallback = function(event)
        local transaction = event.transaction
        local tstate = transaction.state
        local productIdentifier = transaction.productIdentifier

        _showLoader(false)

        local numThemeId
        local numProductId
        if productIdentifier ~= nil then
            numThemeId = tonumber(string.sub(productIdentifier, -2))
            numProductId = 0
            if numThemeId == nil then
                for i=1, #_TBL_IAP_PRODUCTS do
                    if productIdentifier == _TBL_IAP_PRODUCTS[i][1] then
                        numProductId = i
                        break
                    end
                end
            end
        end

        if tstate == "purchased" or tstate == "restored" then
            -- FOR APPLE STORE
            Store.finishTransaction(transaction)

            if numThemeId == nil then
                -- UNLOCK THEMES
                if numProductId == 2 or numProductId == 3 then
                    local tblBuyed = {}
                    for id=1, #_TBL_IAP_THEMES do
                        tblBuyed["t"..string.format("%02d", id)] = true
                    end
                    globals_persistence:set("tThemeBuyed", tblBuyed)
                end

                -- REMOVE ADS
                if numProductId == 1 or numProductId == 3 then
                    globals_persistence:set("ads", false)
                end

                _updateButtons(_NUM_THEME_SELECTED, true)
                
            elseif numThemeId <= #_TBL_IAP_THEMES then
                -- UNLOCK THEME
                local tblBuyed = globals_persistence:get("tThemeBuyed")
                tblBuyed["t"..string.format("%02d", numThemeId)] = true
                globals_persistence:set("tThemeBuyed", tblBuyed)

                local grp = (scvThemes.getView and scvThemes:getView()[1]) and scvThemes:getView()[1] or nil
                if grp and grp[numThemeId] and grp[numThemeId].setFrame then
                    grp[numThemeId]:setFrame(1)
                end

                if _NUM_THEME_SELECTED == numThemeId then
                    _updateButtons(numThemeId, true)
                end
            end

            Toast.show(tstate, {duration="long"})

        -- FOR GOOGLE PLAY V3
        elseif tstate == "consumed" then


        elseif tstate == "refunded" then
            -- FOR APPLE STORE
            Store.finishTransaction(transaction)

            if numThemeId == nil then
                -- RETURN ADS
                if numProductId == 1 or numProductId == 3 then
                    globals_persistence:set("ads", true)
                end
            elseif numThemeId <= #_TBL_IAP_THEMES then
                -- LOCK THEME
                local tblBuyed = globals_persistence:get("tThemeBuyed")
                tblBuyed["t"..string.format("%02d", numThemeId)] = false
                globals_persistence:set("tThemeBuyed", tblBuyed)

                local grp = (scvThemes.getView and scvThemes:getView()[1]) and scvThemes:getView()[1] or nil
                if grp and grp[numThemeId] and grp[numThemeId].setFrame then
                    grp[numThemeId]:setFrame(2)
                end
            end

            Toast.show(tstate, {duration="long"})

        elseif tstate == "cancelled" then
            -- FOR APPLE STORE
            Store.finishTransaction(transaction)

            Toast.show(tstate, {duration="long"})
            
        elseif tstate == "failed" then
            -- FOR APPLE STORE
            Store.finishTransaction(transaction)
            --native.showAlert(" ", transaction.errorString, {"OK"}) -- transaction.errorType
            Toast.show(transaction.errorString, {duration="long"})

        else
            -- FOR APPLE STORE
            Store.finishTransaction(transaction)

        end

        Util:hideStatusbar()
    end


    -- INIT STORE
    Store.init(transactionCallback)


    for id=1, #_TBL_IAP_THEMES_FRAMES do
        local sptTheme = display.newSprite(_SHT_THEMES, { {name="standard", frames=_TBL_IAP_THEMES_FRAMES[id]} })
        sptTheme.anchorX, sptTheme.anchorY = .5, .5
        sptTheme.x, sptTheme.y = 220 + _NUM_BUTTON_DIST * (id - 1), 250
        sptTheme.xScale, sptTheme.yScale = _NUM_ICON_SCALE_MIN, _NUM_ICON_SCALE_MIN
        sptTheme.id = id
        sptTheme.xSelectedPosition = display.contentCenterX - sptTheme.x + 40
        scvThemes:insert(sptTheme)

        local isBuyed = globals_persistence:get("tThemeBuyed")["t"..string.format("%02d", id)]
        sptTheme:setFrame(isBuyed and 1 or 2)
    end


    scvThemes:setScrollWidth(#_TBL_IAP_THEMES_FRAMES * _NUM_BUTTON_DIST + 220 + 128)


    local function btnThemeSelectedEvent( event )
        if event.phase == "ended" then
            Jukebox:dispatchEvent({name="playSound", id="button"})
            
            local isBuyed = globals_persistence:get("tThemeBuyed")["t"..string.format("%02d", _NUM_THEME_SELECTED)]

            if isBuyed then
                transition.to(sptSelect, {alpha=0, time=1})
                transition.to(btnSelect, {alpha=0, time=1, onComplete=function()
                    Controller:setTheme(_NUM_THEME_SELECTED)

                    if NUM_THEME_CURRENT ~= _NUM_THEME_SELECTED then
                        Composer.stage.alpha = 0
                        local options = {
                            effect = "fade",
                            time = 0,
                            params = {scene="classes.superpop.controller.scenes.Frontend"}
                        }
                        Composer.gotoScene("classes.superpop.controller.scenes.LoadingScene", options)
                    else
                        Controller:hideOverlay(200)
                    end
                end})
            end
        end
        return false
    end
    btnSelect = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 60,
        overFrame = 61,
        onEvent = btnThemeSelectedEvent
    }
    grpView:insert(btnSelect)
    btnSelect.anchorX, btnSelect.anchorY = .5, .5
    btnSelect.x, btnSelect.y = display.contentCenterX, display.contentCenterY + 125
    btnSelect:scale(.001, .001)
    transition.to(btnSelect, {xScale=1, yScale=1, delay=300, time=600, transition=easing.outElastic})


    local function btnThemeBuyEvent( event )
        local phase = event.phase

        if phase == "moved" then
            local dy = abs(event.y - event.yStart)
            if dy > 10 then
                scvThemes:takeFocus(event)
            end
        elseif phase == "ended" then
            
            if not Store.isActive or (not Store.canMakePurchases and Store.target == "apple") then
                Jukebox:dispatchEvent({name="playSound", id="negation"})
                --native.showAlert(" ", "Store inactive", {"OK"})
                Toast.show("Store inactive", {duration="long"})
            else
                if Store.target == "apple" then
                    Jukebox:dispatchEvent({name="playSound", id="button"})
                    _showLoader(true)
                    Store.purchase({_TBL_IAP_THEMES[_NUM_THEME_SELECTED][1]})
                elseif Store.target == "google" then
                    Jukebox:dispatchEvent({name="playSound", id="button"})
                    _showLoader(true)
                    Store.purchase(_TBL_IAP_THEMES[_NUM_THEME_SELECTED][1])
                else
                    Jukebox:dispatchEvent({name="playSound", id="negation"})
                    --native.showAlert(" ", "Store inactive", {"OK"})
                    Toast.show("Store inactive", {duration="long"})
                end
            end
        end
        return false
    end
    btnBuy = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 57,
        overFrame = 57,
        onEvent = btnThemeBuyEvent
    }
    grpView:insert(btnBuy)
    btnBuy.anchorX, btnBuy.anchorY = .5, .5
    btnBuy.x, btnBuy.y = display.contentCenterX, display.contentCenterY + 125
    btnBuy.isVisible = false
    btnBuy.alpha = 0
    transition.to(btnBuy, {alpha=1, delay=300, time=600})


    txtPrice = display.newText("", 0, 0, Constants.TBL_STYLE.FAMILY, 16)
    grpView:insert(txtPrice)
    txtPrice:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
    txtPrice.anchorX, txtPrice.anchorY = .5, .5
    txtPrice.x, txtPrice.y = btnBuy.x, btnBuy.y
    txtPrice.isVisible = false


    sptBG:toBack()
    rctOverlay:toBack()


    local function btnBuyEvent( event )
        if "ended" == event.phase then
            Jukebox:dispatchEvent({name="playSound", id="button"})
            local options = {
                isModal = true,
                effect = "fade",
                time = 0,
            }
            Composer.showOverlay("classes.superpop.controller.scenes.Buy", options)
        end
    end
    local btnBuy = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 55,
        overFrame = 56,
        onEvent = btnBuyEvent
    }
    grpView:insert(btnBuy)
    btnBuy.anchorX, btnBuy.anchorY = .5, .5
    btnBuy.x, btnBuy.y = Constants.LEFT + btnBuy.width * .5, Constants.TOP + btnBuy.height * .5
    btnBuy.alpha = 0
    transition.to(btnBuy, {alpha=1, delay=100, time=600})


    local btnMenu = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 68,
        overFrame = 69,
        onEvent = btnBackRelease
    }
    grpView:insert(btnMenu)
    btnMenu.anchorX, btnMenu.anchorY = .5, .5
    btnMenu.x, btnMenu.y = Constants.LEFT + btnMenu.width * .5, Constants.BOTTOM - btnMenu.height * .5
    btnMenu.alpha = 0
    transition.to(btnMenu, {alpha=1, delay=500, time=600})


    local function btnRestoreEvent( event )
        local phase = event.phase

        if phase == "ended" then
            if not Store.isActive or (not Store.canMakePurchases and Store.target == "apple") then
                Jukebox:dispatchEvent({name="playSound", id="negation"})
                Toast.show("Store inactive", {duration="long"})
            else
                Jukebox:dispatchEvent({name="playSound", id="button"})
                _showLoader(true)
                transition.to(grpView, {time=10000, onComplete=function()
                    if _showLoader then
                        _showLoader(false)
                    end
                end})
                Store.restore()
            end
        end
    end
    local btnRestore = Widget.newButton{
        sheet = _SHT_UTIL,
        defaultFrame = 41,
        overFrame = 42,
        onEvent = btnRestoreEvent
    }
    grpView:insert(btnRestore)
    btnRestore.anchorX, btnRestore.anchorY = .5, .5
    btnRestore.x, btnRestore.y = Constants.RIGHT - btnMenu.width * .5, Constants.TOP + btnMenu.height * .5
    btnRestore.alpha = 0
    transition.to(btnRestore, {alpha=1, delay=100, time=600})


end


function objScene:show(event)
    local grpView = self.view
    local phase = event.phase
    local parent = event.parent
    local params = self.params

    if phase == "will" then

    elseif phase == "did" then

        local numThemeId = (params and params.numThemeTo) and params.numThemeTo or globals_persistence:get("nThemeCurrent")
        _moveScrollTo(numThemeId)

    end
end


function objScene:hide(event)
    local grpView = self.view
    local phase = event.phase
    local parent = event.parent

    if phase == "did" then

        globals_btnBackRelease = nil

        Util:hideStatusbar()

    end
end


objScene:addEventListener("create", objScene)
objScene:addEventListener("show", objScene)
objScene:addEventListener("hide", objScene)


return objScene