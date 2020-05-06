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
            x=995,
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
            y=521,
            width=748,
            height=191,

            sourceX = 0,
            sourceY = 222,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0002
            x=4,
            y=860,
            width=197,
            height=57,

            sourceX = 275,
            sourceY = 332,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0003
            x=4,
            y=4,
            width=750,
            height=511,

            sourceX = 0,
            sourceY = 239,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0004
            x=4,
            y=718,
            width=217,
            height=136,

            sourceX = 266,
            sourceY = 337,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0005
            x=760,
            y=4,
            width=229,
            height=500,

            sourceX = 99,
            sourceY = 120,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0006
            x=227,
            y=718,
            width=61,
            height=131,

            sourceX = 303,
            sourceY = 308,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0007
            x=760,
            y=510,
            width=187,
            height=464,

            sourceX = 439,
            sourceY = 162,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0008
            x=953,
            y=510,
            width=51,
            height=124,

            sourceX = 388,
            sourceY = 318,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0009
            x=953,
            y=640,
            width=14,
            height=14,

            sourceX = 368,
            sourceY = 368,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0010
            x=973,
            y=640,
            width=12,
            height=12,

            sourceX = 369,
            sourceY = 369,
            sourceWidth = 750,
            sourceHeight = 750
        },
    },
    
    sheetContentWidth = 1009,
    sheetContentHeight = 978
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
