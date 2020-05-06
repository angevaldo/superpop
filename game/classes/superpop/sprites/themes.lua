--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:65e3f4ac056c6a09a67cae95e12e3a8a:32853e3b84ad4def9f2efc3ec30e33d0:3539c45cfded93c33ebfd1718b4369fc$
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
            x=4,
            y=4,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0001
            x=4,
            y=134,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0002
            x=4,
            y=264,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0003
            x=134,
            y=4,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0004
            x=134,
            y=134,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0005
            x=134,
            y=264,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0006
            x=264,
            y=4,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0007
            x=264,
            y=134,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0008
            x=264,
            y=264,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0009
            x=394,
            y=4,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0010
            x=394,
            y=134,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0011
            x=394,
            y=264,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0012
            x=524,
            y=4,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0013
            x=654,
            y=4,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0014
            x=524,
            y=134,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 001/0015
            x=524,
            y=264,
            width=124,
            height=124,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 128,
            sourceHeight = 128
        },
    },
    
    sheetContentWidth = 782,
    sheetContentHeight = 392
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
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
