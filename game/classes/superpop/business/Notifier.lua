local notifications = require "plugin.notifications" 


local Persistence = require "classes.superpop.persistence.Persistence"
local Constants = require "classes.superpop.business.Constants"


local Notifier = {}


local _STR_EXTENSION = ".mp3"
if system.getInfo("platformName") == "iPhone OS" or system.getInfo("platformName") == "Mac OS X" then _STR_EXTENSION = ".caf" end


local _TBL_NOTIFICATIONS = {
	{name="missYou", alert=Constants.STR_MISS_YOU_MESSAGE_NOTIFICATION, time=(Constants.NUM_DAYS_WITHOUT_PLAY_TO_MISS_YOU_MESSAGE_NOTIFICATION * 24 * 60 * 60)},
	{name="newGift", alert=Constants.STR_NEW_GIFT_MESSAGE_NOTIFICATION},
}


local _schedule = function(self, id, params)
	local tblNotifications = _TBL_NOTIFICATIONS[id]

    local numTimeToNofify = (params and params.time) or tblNotifications.time
    local numTimeNow = os.time()
    local dNotified = globals_persistence:get("dNotified"..id) or numTimeNow
    local numDifDateNotified = os.difftime(dNotified, numTimeNow)

    if tblNotifications.handle ~= nil or numDifDateNotified == 0 or numDifDateNotified > numTimeToNofify then
        if tblNotifications.handle ~= nil then
            notifications.cancelNotification(tblNotifications.handle)
            tblNotifications.handle = nil
        end

        local badge_num = native.getProperty("applicationIconBadgeNumber")
        badge_num = badge_num and (badge_num + 1) or 1

        local options = {
            alert = tblNotifications.alert,
            badge = badge_num,
            sound = "audio/pop2".._STR_EXTENSION,
            custom = {name = tblNotifications.name}
        }

        tblNotifications.handle = notifications.scheduleNotification(numTimeToNofify, options)

        globals_persistence:set("isNotified"..id, true)
        globals_persistence:set("dNotified"..id, os.time())
    end
end

local _getID = function(name)
    if _TBL_NOTIFICATIONS then
        for i=1, #_TBL_NOTIFICATIONS do
            if name == _TBL_NOTIFICATIONS[i].name then
                return i
            end
        end
    end
    return nil
end

local _notificationListener = function(self, event)
    if event and event.type == "local" then
        local params = event.custom
        if params and params.name then
            local numId = _getID(params.name)

            if numId then
                globals_persistence:set("isNotified"..numId, false)
                globals_persistence:set("dNotified"..numId, nil)
            end
         end
    end
end


Notifier.schedule = _schedule
Notifier.notificationListener = _notificationListener
Runtime:addEventListener("notification", function(event) if Notifier and Notifier.notificationListener then Notifier:notificationListener(event) end end)

return Notifier