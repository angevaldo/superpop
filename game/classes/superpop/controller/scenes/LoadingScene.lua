local Composer = require "composer"
local objScene = Composer.newScene()


local Util = require "classes.superpop.business.Util"


local Trt = require "lib.Trt"


function objScene:create(event)
    local grpView = self.view

    Trt.cancelAll() -- clean animes transitions
end

function objScene:show(event)
    local grpView = self.view
    local phase = event.phase

    local params = event.params

    if phase == "will" then

        globals_btnBackRelease = nil

    elseif phase == "did" then

        -- REMOVE STATUS BAR
        Util:hideStatusbar()

        -- clean memory
        Composer:removeHidden(true) -- clean textures and variables/tables
        if not params.reloadMode then
            Composer:removeScene("classes.superpop.controller.scenes.Frontend") -- force clean gameplay
            collectgarbage()
        end

        -- setting default
        if params == nil then
            params = {}
        end
        if params.scene == nil then
            params.scene = "classes.superpop.controller.scenes.Frontend"
        end

        transition.to(grpView, {time=1, onComplete=function()
            local options = {
                effect = "fade",
                time = params.reloadMode and 0 or 100,
                params = params
            }
            Composer.gotoScene(params.scene, options)
        end})

    end
end


objScene:addEventListener("create", objScene)
objScene:addEventListener("show", objScene)


return objScene