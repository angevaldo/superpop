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


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local _TBL_IAP_THEMES = Constants.TBL_IAP_THEMES
local _TBL_IAP_PRODUCTS = Constants.TBL_IAP_PRODUCTS

local _NUM_ICON_SCALE_MIN = .5
local _NUM_BUTTON_DIST = 100


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


function objScene:create()
    local grpView = self.view


    globals_btnBackRelease = btnBackRelease


    local rctOverlay = display.newRect(grpView, -10, -10, 350, 500)
    rctOverlay.anchorX, rctOverlay.anchorY = 0, 0
    rctOverlay:setFillColor(0, .9)


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
            elseif numThemeId <= #_TBL_IAP_THEMES then
                -- UNLOCK THEME
                local tblBuyed = globals_persistence:get("tThemeBuyed")
                tblBuyed["t"..string.format("%02d", numThemeId)] = true
                globals_persistence:set("tThemeBuyed", tblBuyed)
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


    local grpItens = display.newGroup()
    grpView:insert(grpItens)

    local function btnBuyEvent( event )
        local phase = event.phase

        if phase == "ended" then            
            if not Store.isActive or (not Store.canMakePurchases and Store.target == "apple") then
                Jukebox:dispatchEvent({name="playSound", id="negation"})
                --native.showAlert(" ", "Store inactive", {"OK"})
                Toast.show("Store inactive", {duration="long"})
            else
                if Store.target == "apple" then
                    Jukebox:dispatchEvent({name="playSound", id="button"})
                    _showLoader(true)
                    Store.purchase({_TBL_IAP_PRODUCTS[event.target.id][1]})
                elseif Store.target == "google" then
                    Jukebox:dispatchEvent({name="playSound", id="button"})
                    _showLoader(true)
                    Store.purchase(_TBL_IAP_PRODUCTS[event.target.id][1])
                else
                    Jukebox:dispatchEvent({name="playSound", id="negation"})
                    --native.showAlert(" ", "Store inactive", {"OK"})
                    Toast.show("Store inactive", {duration="long"})
                end
            end
        end
        return false
    end

    local function btnBuyedEvent( event )
        local phase = event.phase

        if phase == "ended" then            
            Jukebox:dispatchEvent({name="playSound", id="negation"})
            Toast.show("Already purchased", {duration="long"})
        end
        return false
    end

    local isAllThemesBuyed = true
    local tblBuyed = globals_persistence:get("tThemeBuyed")
    for id=1, #_TBL_IAP_THEMES do
        if not tblBuyed["t"..string.format("%02d", id)] then
            isAllThemesBuyed = false
            break
        end
    end
    local TBL_IAP_PRODUCTS_ALPHA = {
        not globals_persistence:get("ads") and .5 or 1,
        isAllThemesBuyed and .5 or 1,
        (isAllThemesBuyed and not globals_persistence:get("ads")) and .5 or 1
    }

    for i=1, 3 do
        local btnBuy = Widget.newButton{
            sheet = _SHT_UTIL,
            defaultFrame = 57,
            overFrame = 57,
            onEvent = TBL_IAP_PRODUCTS_ALPHA[i] == 1 and btnBuyEvent or btnBuyedEvent
        }
        grpItens:insert(btnBuy)
        btnBuy.anchorX, btnBuy.anchorY = .5, .5
        btnBuy.x, btnBuy.y = 150, 95 * i
        btnBuy.alpha = TBL_IAP_PRODUCTS_ALPHA[i]
        btnBuy:scale(.001, .001)

        btnBuy.id = i
        transition.to(btnBuy, {xScale=1, yScale=1, delay=100 * i, time=600, transition=easing.outElastic})

        local txtPrice = display.newText(_TBL_IAP_PRODUCTS[i][2], 0, 0, Constants.TBL_STYLE.FAMILY, 16)
        grpItens:insert(txtPrice)
        txtPrice:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
        txtPrice.anchorX, txtPrice.anchorY = .5, .5
        txtPrice.x, txtPrice.y = btnBuy.x, btnBuy.y

        local txtTitle = display.newText(_TBL_IAP_PRODUCTS[i][3], 0, 0, Constants.TBL_STYLE.FAMILY, 12)
        grpItens:insert(txtTitle)
        txtTitle:setFillColor(Constants.TBL_STYLE.COLOR[1], Constants.TBL_STYLE.COLOR[2], Constants.TBL_STYLE.COLOR[3], Constants.TBL_STYLE.COLOR[4])
        txtTitle.anchorX, txtTitle.anchorY = 1, .5
        txtTitle.x, txtTitle.y = btnBuy.x - 40, btnBuy.y + 18

        local sptLogo = display.newSprite(_SHT_UTIL, { {name="s", start=228+i, count=1} })
        grpItens:insert(sptLogo)
        sptLogo.anchorX, sptLogo.anchorY = 1, .5
        sptLogo.x, sptLogo.y = btnBuy.x - 40, btnBuy.y - 8
    end

    grpItens.anchorChildren = true
    grpItens.anchorX, grpItens.anchorY = .5, .5
    grpItens.x, grpItens.y = display.contentCenterX, display.contentCenterY
    grpItens.alpha = 0
    transition.to(grpItens, {alpha=1, delay=200, time=500})


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
    transition.to(btnMenu, {alpha=1, delay=400, time=600})


    local function btnRestoreEvent(event)
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

    if phase == "will" then

    elseif phase == "did" then

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