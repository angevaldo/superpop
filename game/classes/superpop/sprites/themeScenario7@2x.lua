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
            x=1520,
            y=8,
            width=20,
            height=964,

            sourceX = 740,
            sourceY = 268,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0001
            x=8,
            y=8,
            width=1500,
            height=1500,

        },
        {
            -- 001/0002
            x=1520,
            y=984,
            width=396,
            height=392,

            sourceX = 552,
            sourceY = 556,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0003
            x=1552,
            y=192,
            width=272,
            height=156,

            sourceX = 614,
            sourceY = 672,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0004
            x=1552,
            y=524,
            width=84,
            height=60,

            sourceX = 708,
            sourceY = 720,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0005
            x=1552,
            y=8,
            width=272,
            height=172,

            sourceX = 614,
            sourceY = 664,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0006
            x=1748,
            y=1388,
            width=84,
            height=64,

            sourceX = 708,
            sourceY = 718,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0007
            x=1552,
            y=360,
            width=264,
            height=152,

            sourceX = 618,
            sourceY = 674,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0008
            x=1552,
            y=596,
            width=84,
            height=56,

            sourceX = 708,
            sourceY = 722,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0009
            x=1520,
            y=1388,
            width=216,
            height=116,

            sourceX = 642,
            sourceY = 692,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0010
            x=1844,
            y=1388,
            width=72,
            height=48,

            sourceX = 714,
            sourceY = 726,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
    },
    
    sheetContentWidth = 1924,
    sheetContentHeight = 1516
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
