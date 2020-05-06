--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b41f2ff02c0d4bf2b2b9e0d552866b36:4c714ff6730256a057cc98248855c8db:9bc5fed8c311a5fb22325295ebd6151e$
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
            x=3756,
            y=1280,
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
            height=2696,

            sourceX = 0,
            sourceY = 228,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0002
            x=3040,
            y=16,
            width=872,
            height=704,

            sourceX = 1052,
            sourceY = 1168,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0003
            x=3040,
            y=2888,
            width=296,
            height=304,

            sourceX = 1352,
            sourceY = 1348,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0004
            x=3756,
            y=1160,
            width=96,
            height=96,

            sourceX = 1452,
            sourceY = 1452,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0005
            x=3040,
            y=2272,
            width=576,
            height=156,

            sourceX = 1212,
            sourceY = 1372,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0006
            x=3516,
            y=2568,
            width=176,
            height=80,

            sourceX = 1412,
            sourceY = 1448,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0007
            x=3040,
            y=2452,
            width=452,
            height=184,

            sourceX = 1276,
            sourceY = 1392,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0008
            x=3756,
            y=936,
            width=144,
            height=88,

            sourceX = 1428,
            sourceY = 1452,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0009
            x=3040,
            y=2660,
            width=420,
            height=204,

            sourceX = 1300,
            sourceY = 1384,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0010
            x=3756,
            y=1048,
            width=140,
            height=88,

            sourceX = 1432,
            sourceY = 1452,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0011
            x=3040,
            y=2052,
            width=600,
            height=196,

            sourceX = 1212,
            sourceY = 1364,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0012
            x=3516,
            y=2452,
            width=180,
            height=92,

            sourceX = 1412,
            sourceY = 1444,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0013
            x=16,
            y=2736,
            width=3000,
            height=472,

            sourceX = 0,
            sourceY = 1116,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0014
            x=3040,
            y=744,
            width=864,
            height=168,

            sourceX = 1068,
            sourceY = 1380,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0015
            x=3040,
            y=936,
            width=692,
            height=1092,

            sourceX = 1156,
            sourceY = 488,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
        {
            -- 001/0016
            x=3876,
            y=1160,
            width=6,
            height=6,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 3000,
            sourceHeight = 3000
        },
    },
    
    sheetContentWidth = 3928,
    sheetContentHeight = 3224
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
