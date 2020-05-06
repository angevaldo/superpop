--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:0dfb28f1ce6e615476649e4cc6e0842d:cb8633ffb8316cd66f79b47a1967665a:2906402fd79c877f477aaddbf8e96edb$
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
            x=971,
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
            y=4,
            width=750,
            height=599,

            sourceX = 0,
            sourceY = 151,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0002
            x=760,
            y=4,
            width=205,
            height=173,

            sourceX = 269,
            sourceY = 315,
            sourceWidth = 750,
            sourceHeight = 750
        },
    },
    
    sheetContentWidth = 985,
    sheetContentHeight = 607
}

SheetInfo.frameIndex =
{

    ["001/0000"] = 1,
    ["001/0001"] = 2,
    ["001/0002"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
