
-- HIDDEN BAR
local Util = require "classes.superpop.business.Util"
Util:hideStatusbar()

-- GLOBAL FUNCTIONS
globals_btnBackRelease = function(event) end

-- GLOBAL ATTRIBUTES
local Persistence = require "classes.superpop.persistence.Persistence"
globals_persistence = Persistence:new()

-- PREPARE SCREEN
display.setDefault("background", 1)
system.deactivate("multitouch")

-- HANDLING NOTIFICATIONS
local launchArgs = ...
if launchArgs and launchArgs.notification then
	local Notifier = require "classes.superpop.business.Notifier"
    Notifier:notificationListener(launchArgs.notification)
end

-- FACEBOOK CAMPAINS REGISTRATION
local facebook = require "plugin.facebook.v4"
facebook.publishInstall()

-- INIT ADS
globals_adCallbackListener = function(params) end
local AdsGame = require "classes.superpop.business.AdsGame"
AdsGame:init()

-- INIT GAME
local Composer = require "composer"
Composer.gotoScene("classes.superpop.controller.scenes.Init")

-- SETTING MEMORY AUTO CLEAN
local function _onMemoryWarning( event )
	Composer:removeHidden(true)
end
Runtime:addEventListener("memoryWarning", _onMemoryWarning)

-------------------------------------

-- DEBUGS (DESACTIVATE ON PRODUCTION)
--[[]
-- GLOBALS
local _TBL_RESERVED = {"_G","_network_pathForFile","mime","ltn12","socket","_VERSION","al","assert","audio","collectgarbage","coronabaselib","coroutine","debug","display","dofile","easing","error","gcinfo","getfenv","getmetatable","graphics","io","ipairs","lfs","load","loadfile","loadstring","lpeg","math","media","metatable","module","native","network","newproxy","next","os","package","pairs","pcall","physics","print","rawequal","rawget","rawset","require","Runtime","select","setfenv","setmetatable","string","system","table","Timer","tonumber","tostring","transition","type","unpack","xpcall"}
for k, v in pairs( _G ) do
	local isReserved = false
	for i, j in pairs( _TBL_RESERVED ) do
		if k == j then
			isReserved = true
			break
		end
	end
	if not isReserved then
	   print( k .. " => ", v )
	end
end
--]]