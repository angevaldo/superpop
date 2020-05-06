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
            x=3884,
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
            height=2396,

            sourceX = 0,
            sourceY = 604,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0002
            x=3040,
            y=16,
            width=820,
            height=692,

            sourceX = 1076,
            sourceY = 1260,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
    },
    
    sheetContentWidth = 3940,
    sheetContentHeight = 2428
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
