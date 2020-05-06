local GameNetwork = require "gameNetwork"


local Util = require "classes.superpop.business.Util"
local Controller = require "classes.superpop.business.Controller"
local Constants = require "classes.superpop.business.Constants"


local infUtil = require("classes.superpop.sprites.util")
local _SHT_UTIL = graphics.newImageSheet("images/util.png", infUtil:getSheet())


local Ranking = {}


local isToLoadPhoto = system.getInfo("platformName") == "iPhone OS"


function Ranking:new(params)
    local isHorizontal = params.isHorizontal
    local gameMode = params.gameMode

    local ranking = display.newGroup()

    local idPlayer = globals_persistence:get("playerID")
    local strAliasPlayer = globals_persistence:get("sAlias") or Constants.STR_ALIAS_ME_RANKING
    local rankPlayer = globals_persistence:get("nRank"..gameMode)
    -- print("player", idPlayer, strAliasPlayer, rankPlayer)

    if idPlayer and rankPlayer and rankPlayer > 0 then

        local tblPlayers = {{
            id = idPlayer, 
            alias = strAliasPlayer, 
            rank = rankPlayer,
            isMe = true,
        }}

        for i=1, Constants.NUM_FRIENDS_TO_LOAD_RANKING do
            local idFriend = globals_persistence:get("playerIDFriend"..i..gameMode)
            local rankFriend = globals_persistence:get("nRankFriend"..i..gameMode)
            -- print("friend", idFriend, rankFriend)

            if idFriend and idFriend ~= idPlayer and rankFriend and rankFriend > 0 then
                local aliasFriend = globals_persistence:get("sAliasFriend"..i..gameMode)

                tblPlayers[#tblPlayers + 1] = {
                    id = idFriend, 
                    alias = aliasFriend or Constants.STR_ALIAS_UNKNOW_RANKING, 
                    rank = rankFriend,
                    isMe = false,
                }
            end
        end
        table.sort(tblPlayers, function(a,b) return a.rank < b.rank end)

        local numMaxWidth = 0
        local numMaxHeight = 0

        -- print("#tblFriends", #tblPlayers)
        for i=1, #tblPlayers do

            local numPosY = isHorizontal and (i - 1) * 23 or (i - 1) * 38
            local tblColorMe = tblPlayers[i].isMe and Constants.TBL_STYLE.COLOR_FOCUS or Constants.TBL_STYLE.COLOR
            local tblColor = Constants.TBL_STYLE.COLOR

            local grpPosition = display.newGroup()

            if isToLoadPhoto then

                local grpPhoto = display.newGroup()
                grpPosition:insert(grpPhoto)

                local sptBG = display.newSprite(_SHT_UTIL, { {name="s", start=250, count=1} })
                sptBG.anchorX, sptBG.anchorY = .5, .5
                sptBG.x, sptBG.y = 0, 0
                grpPhoto:insert(sptBG)

                -- LOAD PHOTO
                local function _loadPhoto(event)
                    if ranking and ranking.insert and event and event.data and event.data.photo then
                        local image = event.data.photo
                        image.width, image.height = 15, 15
                        image.anchorX, image.anchorY = .5, .5
                        image.x, image.y = 0, 0

                        grpPhoto:insert(image)
                        image:toBack()
                        sptBG:toBack()
                    elseif event and event.data and event.data.photo then
                        event.data.photo:removeSelf()
                        event.data.photo = nil
                    end
                end

                GameNetwork.request("loadPlayerPhoto", {playerID=tblPlayers[i].id, size="Small", listener=_loadPhoto})

                local sptBorder = display.newSprite(_SHT_UTIL, { {name="s", start=251, count=1} })
                sptBorder.anchorX, sptBorder.anchorY = .5, .5
                sptBorder.x, sptBorder.y = 0, 0
                sptBorder:setFillColor(tblColor[1], tblColor[2], tblColor[3], tblColor[4])
                grpPhoto:insert(sptBorder)

                grpPhoto.anchorX, grpPhoto.anchorY = .5, .5
                grpPhoto.x, grpPhoto.y = 0, 0

            end

            local txtRank = display.newText(grpPosition, "#"..Util:formatNumber(tblPlayers[i].rank), 0, 0, Constants.TBL_STYLE.FAMILY, (isHorizontal and 13 or 15))
            txtRank:setFillColor(tblColor[1], tblColor[2], tblColor[3], tblColor[4])
            txtRank.anchorX, txtRank.anchorY = 0, .5
            txtRank.x, txtRank.y = isToLoadPhoto and 12 or 6, 0

            grpPosition.anchorChildren = true
            grpPosition.anchorX, grpPosition.anchorY = isHorizontal and 0 or .5, .5
            grpPosition.x, grpPosition.y = 0, numPosY
            ranking:insert(grpPosition)

            local txtAlias = display.newText(ranking, tblPlayers[i].alias, 0, 0, Constants.TBL_STYLE.FAMILY, isHorizontal and 10 or 9)
            txtAlias:setFillColor(tblColorMe[1], tblColorMe[2], tblColorMe[3], tblColorMe[4])
            txtAlias.anchorX, txtAlias.anchorY = isHorizontal and 0 or .5, .5
            txtAlias.x, txtAlias.y = isHorizontal and (grpPosition.width + grpPosition.x + 2) or 0, numPosY + (isHorizontal and 0 or (system.getInfo("platformName") == "Android" and 13 or 16))
        end

        local rctBg = display.newRect(0, 0, ranking.width, ranking.height)
        rctBg.alpha = .01
        rctBg.anchorX, rctBg.anchorY = isHorizontal and 0 or .5, 0
        rctBg.x, rctBg.y = 0, -11
        ranking:insert(rctBg)
        rctBg:toBack()

        ranking.anchorChildren = true
        ranking.anchorX, ranking.anchorY = 0, 0
    end

    return ranking
end


return Ranking