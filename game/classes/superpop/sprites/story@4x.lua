--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:de182ec1823dc433d78c5f2be609e356:8f5116c8d74f023af8bc00155203451c:45b0019df457ddb1583086df248020c9$
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
            -- story/0000
            x=2256,
            y=668,
            width=1104,
            height=580,

            sourceX = 124,
            sourceY = 44,
            sourceWidth = 1400,
            sourceHeight = 750
        },
        {
            -- story/0001
            x=16,
            y=16,
            width=1104,
            height=680,

            sourceX = 188,
            sourceY = 40,
            sourceWidth = 1400,
            sourceHeight = 750
        },
        {
            -- story/0002
            x=2248,
            y=16,
            width=1084,
            height=628,

            sourceX = 96,
            sourceY = 12,
            sourceWidth = 1400,
            sourceHeight = 750
        },
        {
            -- story/0003
            x=1144,
            y=16,
            width=1080,
            height=676,

            sourceX = 188,
            sourceY = 68,
            sourceWidth = 1400,
            sourceHeight = 750
        },
        {
            -- story/0004
            x=3356,
            y=16,
            width=368,
            height=584,

            sourceX = 324,
            sourceY = 0,
            sourceWidth = 1400,
            sourceHeight = 750
        },
        {
            -- story/0005
            x=1872,
            y=716,
            width=360,
            height=392,

            sourceX = 544,
            sourceY = 240,
            sourceWidth = 1400,
            sourceHeight = 750
        },
        {
            -- story/0006
            x=16,
            y=720,
            width=944,
            height=460,

            sourceX = 252,
            sourceY = 120,
            sourceWidth = 1400,
            sourceHeight = 750
        },
        {
            -- story/0007
            x=984,
            y=720,
            width=864,
            height=412,

            sourceX = 96,
            sourceY = 188,
            sourceWidth = 1400,
            sourceHeight = 750
        },
    },
    
    sheetContentWidth = 3740,
    sheetContentHeight = 1264
}

SheetInfo.frameIndex =
{

    ["story/0000"] = 1,
    ["story/0001"] = 2,
    ["story/0002"] = 3,
    ["story/0003"] = 4,
    ["story/0004"] = 5,
    ["story/0005"] = 6,
    ["story/0006"] = 7,
    ["story/0007"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
