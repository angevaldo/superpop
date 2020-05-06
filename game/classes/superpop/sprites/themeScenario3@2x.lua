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
            x=1878,
            y=640,
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
            height=1348,

            sourceX = 0,
            sourceY = 114,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0002
            x=1520,
            y=8,
            width=436,
            height=352,

            sourceX = 526,
            sourceY = 584,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0003
            x=1520,
            y=1444,
            width=148,
            height=152,

            sourceX = 676,
            sourceY = 674,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0004
            x=1878,
            y=580,
            width=48,
            height=48,

            sourceX = 726,
            sourceY = 726,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0005
            x=1520,
            y=1136,
            width=288,
            height=78,

            sourceX = 606,
            sourceY = 686,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0006
            x=1758,
            y=1284,
            width=88,
            height=40,

            sourceX = 706,
            sourceY = 724,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0007
            x=1520,
            y=1226,
            width=226,
            height=92,

            sourceX = 638,
            sourceY = 696,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0008
            x=1878,
            y=468,
            width=72,
            height=44,

            sourceX = 714,
            sourceY = 726,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0009
            x=1520,
            y=1330,
            width=210,
            height=102,

            sourceX = 650,
            sourceY = 692,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0010
            x=1878,
            y=524,
            width=70,
            height=44,

            sourceX = 716,
            sourceY = 726,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0011
            x=1520,
            y=1026,
            width=300,
            height=98,

            sourceX = 606,
            sourceY = 682,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0012
            x=1758,
            y=1226,
            width=90,
            height=46,

            sourceX = 706,
            sourceY = 722,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0013
            x=8,
            y=1368,
            width=1500,
            height=236,

            sourceX = 0,
            sourceY = 558,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0014
            x=1520,
            y=372,
            width=432,
            height=84,

            sourceX = 534,
            sourceY = 690,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0015
            x=1520,
            y=468,
            width=346,
            height=546,

            sourceX = 578,
            sourceY = 244,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
        {
            -- 001/0016
            x=1938,
            y=580,
            width=3,
            height=3,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 1500,
            sourceHeight = 1500
        },
    },
    
    sheetContentWidth = 1964,
    sheetContentHeight = 1612
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
