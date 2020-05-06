--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:19d58baa7777b0720a07e926dc590cd2:0f2579e03f7e33341802e626e0750bdc:11d5cb45a7ca73e90002d57ec5813ccf$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")} } )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- 001/0000
            x=3980,
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
            y=2084,
            width=2992,
            height=764,

            sourceX = 0,
            sourceY = 888,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0002
            x=16,
            y=3440,
            width=788,
            height=228,

            sourceX = 1100,
            sourceY = 1328,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0003
            x=16,
            y=16,
            width=3000,
            height=2044,

            sourceX = 0,
            sourceY = 956,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0004
            x=16,
            y=2872,
            width=868,
            height=544,

            sourceX = 1064,
            sourceY = 1348,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0005
            x=3040,
            y=16,
            width=916,
            height=2000,

            sourceX = 396,
            sourceY = 480,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0006
            x=908,
            y=2872,
            width=244,
            height=524,

            sourceX = 1212,
            sourceY = 1232,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0007
            x=3040,
            y=2040,
            width=748,
            height=1856,

            sourceX = 1756,
            sourceY = 648,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0008
            x=3812,
            y=2040,
            width=204,
            height=496,

            sourceX = 1552,
            sourceY = 1272,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0009
            x=3812,
            y=2560,
            width=56,
            height=56,

            sourceX = 1472,
            sourceY = 1472,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0010
            x=3892,
            y=2560,
            width=48,
            height=48,

            sourceX = 1476,
            sourceY = 1476,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
    },
    
    sheetContentWidth = 4036,
    sheetContentHeight = 3912
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
