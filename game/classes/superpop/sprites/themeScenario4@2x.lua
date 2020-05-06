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
            x=1990,
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
            y=1042,
            width=1496,
            height=382,

            sourceX = 0,
            sourceY = 444,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0002
            x=8,
            y=1720,
            width=394,
            height=114,

            sourceX = 550,
            sourceY = 664,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0003
            x=8,
            y=8,
            width=1500,
            height=1022,

            sourceX = 0,
            sourceY = 478,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0004
            x=8,
            y=1436,
            width=434,
            height=272,

            sourceX = 532,
            sourceY = 674,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0005
            x=1520,
            y=8,
            width=458,
            height=1000,

            sourceX = 198,
            sourceY = 240,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0006
            x=454,
            y=1436,
            width=122,
            height=262,

            sourceX = 606,
            sourceY = 616,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0007
            x=1520,
            y=1020,
            width=374,
            height=928,

            sourceX = 878,
            sourceY = 324,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0008
            x=1906,
            y=1020,
            width=102,
            height=248,

            sourceX = 776,
            sourceY = 636,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0009
            x=1906,
            y=1280,
            width=28,
            height=28,

            sourceX = 736,
            sourceY = 736,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0010
            x=1946,
            y=1280,
            width=24,
            height=24,

            sourceX = 738,
            sourceY = 738,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
    },
    
    sheetContentWidth = 2018,
    sheetContentHeight = 1956
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
