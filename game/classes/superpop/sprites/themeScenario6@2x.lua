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
            x=1520,
            y=8,
            width=16,
            height=996,

            sourceX = 742,
            sourceY = 0,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0001
            x=8,
            y=8,
            width=1500,
            height=1376,

            sourceX = 0,
            sourceY = 124,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0002
            x=448,
            y=1396,
            width=440,
            height=390,

            sourceX = 530,
            sourceY = 554,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0003
            x=8,
            y=1396,
            width=428,
            height=408,

            sourceX = 536,
            sourceY = 546,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0004
            x=1370,
            y=1568,
            width=128,
            height=120,

            sourceX = 686,
            sourceY = 690,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0005
            x=204,
            y=1816,
            width=176,
            height=64,

            sourceX = 662,
            sourceY = 718,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0006
            x=492,
            y=1870,
            width=60,
            height=34,

            sourceX = 720,
            sourceY = 734,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0007
            x=1064,
            y=1648,
            width=294,
            height=168,

            sourceX = 602,
            sourceY = 666,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0008
            x=392,
            y=1816,
            width=88,
            height=60,

            sourceX = 706,
            sourceY = 720,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0009
            x=900,
            y=1648,
            width=152,
            height=256,

            sourceX = 674,
            sourceY = 622,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0010
            x=136,
            y=1816,
            width=56,
            height=80,

            sourceX = 722,
            sourceY = 710,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0011
            x=1312,
            y=1396,
            width=160,
            height=160,

            sourceX = 670,
            sourceY = 670,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0012
            x=492,
            y=1798,
            width=56,
            height=60,

            sourceX = 722,
            sourceY = 720,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0013
            x=900,
            y=1396,
            width=400,
            height=240,

            sourceX = 550,
            sourceY = 630,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0014
            x=8,
            y=1816,
            width=116,
            height=80,

            sourceX = 692,
            sourceY = 710,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0015
            x=1370,
            y=1700,
            width=116,
            height=116,

            sourceX = 692,
            sourceY = 692,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0016
            x=560,
            y=1798,
            width=48,
            height=48,

            sourceX = 726,
            sourceY = 726,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
    },
    
    sheetContentWidth = 1544,
    sheetContentHeight = 1912
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
