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
            x=760,
            y=4,
            width=8,
            height=498,

            sourceX = 371,
            sourceY = 0,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0001
            x=4,
            y=4,
            width=750,
            height=688,

            sourceX = 0,
            sourceY = 62,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0002
            x=224,
            y=698,
            width=220,
            height=195,

            sourceX = 265,
            sourceY = 277,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0003
            x=4,
            y=698,
            width=214,
            height=204,

            sourceX = 268,
            sourceY = 273,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0004
            x=685,
            y=784,
            width=64,
            height=60,

            sourceX = 343,
            sourceY = 345,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0005
            x=102,
            y=908,
            width=88,
            height=32,

            sourceX = 331,
            sourceY = 359,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0006
            x=246,
            y=935,
            width=30,
            height=17,

            sourceX = 360,
            sourceY = 367,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0007
            x=532,
            y=824,
            width=147,
            height=84,

            sourceX = 301,
            sourceY = 333,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0008
            x=196,
            y=908,
            width=44,
            height=30,

            sourceX = 353,
            sourceY = 360,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0009
            x=450,
            y=824,
            width=76,
            height=128,

            sourceX = 337,
            sourceY = 311,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0010
            x=68,
            y=908,
            width=28,
            height=40,

            sourceX = 361,
            sourceY = 355,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0011
            x=656,
            y=698,
            width=80,
            height=80,

            sourceX = 335,
            sourceY = 335,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0012
            x=246,
            y=899,
            width=28,
            height=30,

            sourceX = 361,
            sourceY = 360,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0013
            x=450,
            y=698,
            width=200,
            height=120,

            sourceX = 275,
            sourceY = 315,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0014
            x=4,
            y=908,
            width=58,
            height=40,

            sourceX = 346,
            sourceY = 355,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0015
            x=685,
            y=850,
            width=58,
            height=58,

            sourceX = 346,
            sourceY = 346,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0016
            x=280,
            y=899,
            width=24,
            height=24,

            sourceX = 363,
            sourceY = 363,
            sourceWidth = 750,
            sourceHeight = 750
        },
    },
    
    sheetContentWidth = 772,
    sheetContentHeight = 956
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
