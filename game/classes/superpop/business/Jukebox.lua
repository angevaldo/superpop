local Controller = require "classes.superpop.business.Controller"
local Util = require "classes.superpop.business.Util"
local Constants = require "classes.superpop.business.Constants"

local Jukebox = display.newGroup()

local _NUM_THEME_CURRENT = globals_persistence:get("nThemeCurrent")
local _STR_EXTENSION = ".mp3"
if system.getInfo("platformName") == "iPhone OS" or system.getInfo("platformName") == "Mac OS X" then _STR_EXTENSION = ".caf" end

local _TBL_STORY_STASH = {}
local _TBL_SOUNDS_STASH = {}
local _TBL_MUSICS_STASH = {}
local _ID_CURRENT_BACKGROUND_MUSIC = 0
local _CHANNEL_BACKGROUND_MUSIC = 1
local _HANDLE_BACKGROUND_MUSIC = 0

local _TBL_SOUNDS_ID_STORY = {
	tiptoe = "tiptoe",
	draw = "draw",
	fillup = "fillup",
	throw = "throw",
}

local _TBL_SOUNDS_DEFAULT = {
    alarm = "alarm",
    blink = "blink",
    bomb = "bomb",
    boing = "boing",
    burn = "burn",
    button = "button",
    countdown = "countdown",
    coil = "coil",
    collect = "collect",
    collecting = "collecting",
    coin = "coin",
    coinLow = "coinLow",
    look = "look",
    record = "record",
    snoring = "snoring",
    move1 = "move1",
    move2 = "move2",
    move3 = "move3",
    move4 = "move4",
    move5 = "move5",
    move6 = "move6",
    move7 = "move7",
    negation = "negation",
    positive = "positive",
    pop1 = "pop1",
    pop2 = "pop2",
    pop3 = "pop3",
    pop4 = "pop4",
    pop5 = "pop5",
    selected = "selected",
    shock = "shock",
    splash1 = "splash1",
    splash2 = "splash2",
    swoosh = "swoosh",
    tictac = "tictac",
}

local _TBL_SOUNDS_ID_THEME = {}
for i=1,#Constants.TBL_IAP_THEMES do
	_TBL_SOUNDS_ID_THEME[i] = Util:copyTable(_TBL_SOUNDS_DEFAULT)
end

local function stopSound(event)
	if event.channel then
    	audio.stop(event.channel)
    else
    	audio.stop()
    end
end

local function playSound(event) -- id
    return audio.play(_TBL_SOUNDS_STASH[event.id])
end

local function playStory(event) -- id
    audio.play(_TBL_STORY_STASH[event.id])
end

local function _stopMusic()
    _ID_CURRENT_BACKGROUND_MUSIC = 0

	if _HANDLE_BACKGROUND_MUSIC then
	    local result = audio.stop(_CHANNEL_BACKGROUND_MUSIC)
		audio.dispose(_HANDLE_BACKGROUND_MUSIC)
		_HANDLE_BACKGROUND_MUSIC = nil

		-- RELOADING FILES WHEN ERROR
		if result ~= 1 and #_TBL_MUSICS_STASH > 0 then
			Jukebox:activateSounds(false)
			Jukebox:activateSounds(true)
		end

		return true
	end
	return false
end

local function _playMusic(id)
	if _stopMusic() then
    	_playMusic(id)
    else
	    _HANDLE_BACKGROUND_MUSIC = audio.play(_TBL_MUSICS_STASH[id], {channel=_CHANNEL_BACKGROUND_MUSIC, loops=-1})

	    if _HANDLE_BACKGROUND_MUSIC == nil then
    		_playMusic(id)
	    end  	
    end
    
    _ID_CURRENT_BACKGROUND_MUSIC = id
end

local function playMusic(event) 
    if _ID_CURRENT_BACKGROUND_MUSIC ~= event.id then
	    _playMusic(event.id)
	end
	if event.status == 1 then
		audio.setVolume(1, {channel=_CHANNEL_BACKGROUND_MUSIC})
	else
		audio.setVolume(.15, {channel=_CHANNEL_BACKGROUND_MUSIC})
	end
end

local function stopMusic(event)
	_stopMusic()
end

local function activateSounds(self, isActive)
	if isActive then
		if not Jukebox.isActive then
			-- SOUNDS
			for k,v in pairs(_TBL_SOUNDS_ID_THEME[_NUM_THEME_CURRENT]) do
				_TBL_SOUNDS_STASH[k] = audio.loadSound("audio/"..v.._STR_EXTENSION)
			end

			Jukebox:addEventListener("playSound", playSound)
			Jukebox:addEventListener("stopSound", stopSound)

			-- MUSIC
			_TBL_MUSICS_STASH = {
			    audio.loadStream("audio/music".._STR_EXTENSION),
			}

			Jukebox:addEventListener("playMusic", playMusic)
			Jukebox:addEventListener("stopMusic", stopMusic)
		end
	else
		-- SOUNDS
		for i=#_TBL_SOUNDS_STASH, 1 do
			if _TBL_SOUNDS_STASH[i] ~= nil and _TBL_SOUNDS_STASH[i] > 0 then
				audio.stop(_TBL_SOUNDS_STASH[i])
				audio.dispose(_TBL_SOUNDS_STASH[i])
				_TBL_SOUNDS_STASH[i] = nil
			end
		end
		_TBL_SOUNDS_STASH = {}

		Jukebox:removeEventListener("playSound", playSound)
		Jukebox:removeEventListener("stopSound", stopSound)

		-- MUSIC
		for i=#_TBL_MUSICS_STASH, 1 do
			if _TBL_MUSICS_STASH[i] ~= nil and type(_TBL_MUSICS_STASH[i]) ~= "userdata" then
				audio.stop(_TBL_MUSICS_STASH[i])
				audio.dispose(_TBL_MUSICS_STASH[i])
				_TBL_MUSICS_STASH[i] = nil
			end
		end
		_TBL_MUSICS_STASH = {}
		if _HANDLE_BACKGROUND_MUSIC ~= nil and _HANDLE_BACKGROUND_MUSIC > 0 then
			audio.stop(_HANDLE_BACKGROUND_MUSIC)
			audio.dispose(_HANDLE_BACKGROUND_MUSIC)
		end
		_HANDLE_BACKGROUND_MUSIC = nil
		_ID_CURRENT_BACKGROUND_MUSIC = 0

		Jukebox:removeEventListener("playMusic", playMusic)
		Jukebox:removeEventListener("stopMusic", stopMusic)
	end

	Jukebox.isActive = isActive
end

local function activateStory(self, isActive)
	if isActive then
		for k,v in pairs(_TBL_SOUNDS_ID_STORY) do
			_TBL_STORY_STASH[k] = audio.loadSound("audio/"..v.._STR_EXTENSION)
		end

		Jukebox:addEventListener("playStory", playStory)
	else
		for i=#_TBL_STORY_STASH, 1 do
			if _TBL_STORY_STASH[i] ~= nil and _TBL_STORY_STASH[i] > 0 then
				audio.stop(_TBL_STORY_STASH[i])
				audio.dispose(_TBL_STORY_STASH[i])
				_TBL_STORY_STASH[i] = nil
			end
		end
		_TBL_STORY_STASH = {}

		Jukebox:removeEventListener("playStory", playStory)
	end
end

Jukebox.activateSounds = activateSounds
Jukebox.activateStory = activateStory

return Jukebox