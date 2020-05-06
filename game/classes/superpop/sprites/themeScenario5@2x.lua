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
            x=1942,
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
            y=8,
            width=1500,
            height=1198,

            sourceX = 0,
            sourceY = 302,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0002
            x=1520,
            y=8,
            width=410,
            height=346,

            sourceX = 538,
            sourceY = 630,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
    },
    
    sheetContentWidth = 1970,
    sheetContentHeight = 1214
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
