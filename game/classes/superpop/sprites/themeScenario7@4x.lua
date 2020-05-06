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
            x=3040,
            y=16,
            width=40,
            height=1928,

            sourceX = 1480,
            sourceY = 536,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0001
            x=16,
            y=16,
            width=3000,
            height=3000,

        },
        {
            -- 001/0002
            x=3040,
            y=1968,
            width=792,
            height=784,

            sourceX = 1104,
            sourceY = 1112,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0003
            x=3104,
            y=384,
            width=544,
            height=312,

            sourceX = 1228,
            sourceY = 1344,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0004
            x=3104,
            y=1048,
            width=168,
            height=120,

            sourceX = 1416,
            sourceY = 1440,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0005
            x=3104,
            y=16,
            width=544,
            height=344,

            sourceX = 1228,
            sourceY = 1328,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0006
            x=3496,
            y=2776,
            width=168,
            height=128,

            sourceX = 1416,
            sourceY = 1436,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0007
            x=3104,
            y=720,
            width=528,
            height=304,

            sourceX = 1236,
            sourceY = 1348,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0008
            x=3104,
            y=1192,
            width=168,
            height=112,

            sourceX = 1416,
            sourceY = 1444,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0009
            x=3040,
            y=2776,
            width=432,
            height=232,

            sourceX = 1284,
            sourceY = 1384,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0010
            x=3688,
            y=2776,
            width=144,
            height=96,

            sourceX = 1428,
            sourceY = 1452,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
    },
    
    sheetContentWidth = 3848,
    sheetContentHeight = 3032
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
