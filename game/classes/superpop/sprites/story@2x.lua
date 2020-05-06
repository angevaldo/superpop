--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:de182ec1823dc433d78c5f2be609e356:8f5116c8d74f023af8bc00155203451c:45b0019df457ddb1583086df248020c9$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- story/0000
            x=1128,
            y=334,
            width=552,
            height=290,

            sourceX = 62,
            sourceY = 22,
            sourceWidth = 700,
            sourceHeight = 375
        },
        {
            -- story/0001
            x=8,
            y=8,
            width=552,
            height=340,

            sourceX = 94,
            sourceY = 20,
            sourceWidth = 700,
            sourceHeight = 375
        },
        {
            -- story/0002
            x=1124,
            y=8,
            width=542,
            height=314,

            sourceX = 48,
            sourceY = 6,
            sourceWidth = 700,
            sourceHeight = 375
        },
        {
            -- story/0003
            x=572,
            y=8,
            width=540,
            height=338,

            sourceX = 94,
            sourceY = 34,
            sourceWidth = 700,
            sourceHeight = 375
        },
        {
            -- story/0004
            x=1678,
            y=8,
            width=184,
            height=292,

            sourceX = 162,
            sourceY = 0,
            sourceWidth = 700,
            sourceHeight = 375
        },
        {
            -- story/0005
            x=936,
            y=358,
            width=180,
            height=196,

            sourceX = 272,
            sourceY = 120,
            sourceWidth = 700,
            sourceHeight = 375
        },
        {
            -- story/0006
            x=8,
            y=360,
            width=472,
            height=230,

            sourceX = 126,
            sourceY = 60,
            sourceWidth = 700,
            sourceHeight = 375
        },
        {
            -- story/0007
            x=492,
            y=360,
            width=432,
            height=206,

            sourceX = 48,
            sourceY = 94,
            sourceWidth = 700,
            sourceHeight = 375
        },
    },
    
    sheetContentWidth = 1870,
    sheetContentHeight = 632
}

SheetInfo.frameIndex =
{

    ["story/0000"] = 1,
    ["story/0001"] = 2,
    ["story/0002"] = 3,
    ["story/0003"] = 4,
    ["story/0004"] = 5,
    ["story/0005"] = 6,
    ["story/0006"] = 7,
    ["story/0007"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
