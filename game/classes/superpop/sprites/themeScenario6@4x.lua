--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d9238bc55151b9f8d5eaafdbe4bae12e:14620ca0b6185a577b2e25ff2be8cfda:8822420f4c46addd1d6b484db081aa5c$
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
            width=32,
            height=1992,

            sourceX = 1484,
            sourceY = 0,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0001
            x=16,
            y=16,
            width=3000,
            height=2752,

            sourceX = 0,
            sourceY = 248,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0002
            x=896,
            y=2792,
            width=880,
            height=780,

            sourceX = 1060,
            sourceY = 1108,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0003
            x=16,
            y=2792,
            width=856,
            height=816,

            sourceX = 1072,
            sourceY = 1092,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0004
            x=2740,
            y=3136,
            width=256,
            height=240,

            sourceX = 1372,
            sourceY = 1380,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0005
            x=408,
            y=3632,
            width=352,
            height=128,

            sourceX = 1324,
            sourceY = 1436,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0006
            x=984,
            y=3740,
            width=120,
            height=68,

            sourceX = 1440,
            sourceY = 1468,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0007
            x=2128,
            y=3296,
            width=588,
            height=336,

            sourceX = 1204,
            sourceY = 1332,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0008
            x=784,
            y=3632,
            width=176,
            height=120,

            sourceX = 1412,
            sourceY = 1440,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0009
            x=1800,
            y=3296,
            width=304,
            height=512,

            sourceX = 1348,
            sourceY = 1244,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0010
            x=272,
            y=3632,
            width=112,
            height=160,

            sourceX = 1444,
            sourceY = 1420,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0011
            x=2624,
            y=2792,
            width=320,
            height=320,

            sourceX = 1340,
            sourceY = 1340,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0012
            x=984,
            y=3596,
            width=112,
            height=120,

            sourceX = 1444,
            sourceY = 1440,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0013
            x=1800,
            y=2792,
            width=800,
            height=480,

            sourceX = 1100,
            sourceY = 1260,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0014
            x=16,
            y=3632,
            width=232,
            height=160,

            sourceX = 1384,
            sourceY = 1420,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0015
            x=2740,
            y=3400,
            width=232,
            height=232,

            sourceX = 1384,
            sourceY = 1384,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0016
            x=1120,
            y=3596,
            width=96,
            height=96,

            sourceX = 1452,
            sourceY = 1452,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
    },
    
    sheetContentWidth = 3088,
    sheetContentHeight = 3824
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
    ["001/0011"] = 12,
    ["001/0012"] = 13,
    ["001/0013"] = 14,
    ["001/0014"] = 15,
    ["001/0015"] = 16,
    ["001/0016"] = 17,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
