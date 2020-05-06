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
            x=939,
            y=320,
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
            height=674,

            sourceX = 0,
            sourceY = 57,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0002
            x=760,
            y=4,
            width=218,
            height=176,

            sourceX = 263,
            sourceY = 292,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0003
            x=760,
            y=722,
            width=74,
            height=76,

            sourceX = 338,
            sourceY = 337,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0004
            x=939,
            y=290,
            width=24,
            height=24,

            sourceX = 363,
            sourceY = 363,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0005
            x=760,
            y=568,
            width=144,
            height=39,

            sourceX = 303,
            sourceY = 343,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0006
            x=879,
            y=642,
            width=44,
            height=20,

            sourceX = 353,
            sourceY = 362,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0007
            x=760,
            y=613,
            width=113,
            height=46,

            sourceX = 319,
            sourceY = 348,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0008
            x=939,
            y=234,
            width=36,
            height=22,

            sourceX = 357,
            sourceY = 363,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0009
            x=760,
            y=665,
            width=105,
            height=51,

            sourceX = 325,
            sourceY = 346,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0010
            x=939,
            y=262,
            width=35,
            height=22,

            sourceX = 358,
            sourceY = 363,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0011
            x=760,
            y=513,
            width=150,
            height=49,

            sourceX = 303,
            sourceY = 341,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0012
            x=879,
            y=613,
            width=45,
            height=23,

            sourceX = 353,
            sourceY = 361,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0013
            x=4,
            y=684,
            width=750,
            height=118,

            sourceX = 0,
            sourceY = 279,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0014
            x=760,
            y=186,
            width=216,
            height=42,

            sourceX = 267,
            sourceY = 345,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0015
            x=760,
            y=234,
            width=173,
            height=273,

            sourceX = 289,
            sourceY = 122,
            sourceWidth = 750,
            sourceHeight = 750
        },
        {
            -- 001/0016
            x=969,
            y=290,
            width=2,
            height=2,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 750,
            sourceHeight = 750
        },
    },
    
    sheetContentWidth = 982,
    sheetContentHeight = 806
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
