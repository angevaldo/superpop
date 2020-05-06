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
            x=564,
            y=167,
            width=276,
            height=145,

            sourceX = 31,
            sourceY = 11,
            sourceWidth = 350,
            sourceHeight = 188
        },
        {
            -- story/0001
            x=4,
            y=4,
            width=276,
            height=170,

            sourceX = 47,
            sourceY = 10,
            sourceWidth = 350,
            sourceHeight = 188
        },
        {
            -- story/0002
            x=562,
            y=4,
            width=271,
            height=157,

            sourceX = 24,
            sourceY = 3,
            sourceWidth = 350,
            sourceHeight = 188
        },
        {
            -- story/0003
            x=286,
            y=4,
            width=270,
            height=169,

            sourceX = 47,
            sourceY = 17,
            sourceWidth = 350,
            sourceHeight = 188
        },
        {
            -- story/0004
            x=839,
            y=4,
            width=92,
            height=146,

            sourceX = 81,
            sourceY = 0,
            sourceWidth = 350,
            sourceHeight = 188
        },
        {
            -- story/0005
            x=468,
            y=179,
            width=90,
            height=98,

            sourceX = 136,
            sourceY = 60,
            sourceWidth = 350,
            sourceHeight = 188
        },
        {
            -- story/0006
            x=4,
            y=180,
            width=236,
            height=115,

            sourceX = 63,
            sourceY = 30,
            sourceWidth = 350,
            sourceHeight = 188
        },
        {
            -- story/0007
            x=246,
            y=180,
            width=216,
            height=103,

            sourceX = 24,
            sourceY = 47,
            sourceWidth = 350,
            sourceHeight = 188
        },
    },
    
    sheetContentWidth = 935,
    sheetContentHeight = 316
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
