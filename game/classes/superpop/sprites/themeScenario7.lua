--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e518eeb65aa0eb4f73a22fa5cd9d0f4b:b4843b4445a6420a35cde13eee5a3713:ee6eef773ec17be41b646a9ef420a4cf$
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
            -- 001/0000
            x=760,
            y=4,
            width=10,
            height=482,

            sourceX = 370,
            sourceY = 134,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0001
            x=4,
            y=4,
            width=750,
            height=750,

        },
        {
            -- 001/0002
            x=760,
            y=492,
            width=198,
            height=196,

            sourceX = 276,
            sourceY = 278,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0003
            x=776,
            y=96,
            width=136,
            height=78,

            sourceX = 307,
            sourceY = 336,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0004
            x=776,
            y=262,
            width=42,
            height=30,

            sourceX = 354,
            sourceY = 360,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0005
            x=776,
            y=4,
            width=136,
            height=86,

            sourceX = 307,
            sourceY = 332,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0006
            x=874,
            y=694,
            width=42,
            height=32,

            sourceX = 354,
            sourceY = 359,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0007
            x=776,
            y=180,
            width=132,
            height=76,

            sourceX = 309,
            sourceY = 337,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0008
            x=776,
            y=298,
            width=42,
            height=28,

            sourceX = 354,
            sourceY = 361,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0009
            x=760,
            y=694,
            width=108,
            height=58,

            sourceX = 321,
            sourceY = 346,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0010
            x=922,
            y=694,
            width=36,
            height=24,

            sourceX = 357,
            sourceY = 363,
            sourceWidth = 750,
            sourceHeight = 750
        },
    },
    
    sheetContentWidth = 962,
    sheetContentHeight = 758
}

SheetInfo.frameIndex =
{

    ["001/0000"] = 1,
    ["001/0001"] = 2,
    ["001/0002"] = 3,
    ["001/0003"] = 4,
    ["001/0004"] = 5,
    ["001/0005"] = 6,
    ["001/0006"] = 7,
    ["001/0007"] = 8,
    ["001/0008"] = 9,
    ["001/0009"] = 10,
    ["001/0010"] = 11,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
