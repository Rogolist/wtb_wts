--local api = require("wtb_wts/api")
local timeZone = 2
local messlogger = {}
local logFile = {}

--local s, sep, itemLinkText, text, protected, message, timestamp

--messlogger.split = function(s, sep)
function messlogger.split(s, sep)
    local fields = {}
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

--messlogger.itemIdFromItemLinkText = function(itemLinkText)
function messlogger.itemIdFromItemLinkText(itemLinkText)
    local itemIdStr = string.sub(itemLinkText, 3)
    itemIdStr = messlogger.split(itemIdStr, ",")
    itemIdStr = itemIdStr[1]
    return itemIdStr
end 

-- Функція для витягування та заміни частин тексту в квадратних дужках
--messlogger.extractProtected = function(text)
function messlogger.extractProtected(text)
    local protected = {}
    local i = 0
    local modified = text:gsub("%b[]", function(block)
        i = i + 1
        protected[i] = block
        return string.format("[[TOKEN_%d]]", i)
    end)
    return modified, protected
end

-- Відновлює частини тексту, що були в квадратних дужках
--messlogger.restoreProtected = function(text, protected)
function messlogger.restoreProtected(text, protected)
    for i, block in ipairs(protected) do
        text = text:gsub(string.format("%[%[TOKEN_%d%]%]", i), block)
    end
    return text
end


-- магия над мессаджем )
--messlogger.prepareMessage = function(message)
function messlogger.prepareMessage(message)

	-- Заміняємо частини в квадратних дужках на тимчасові токени
	local cleanedMessage, protectedParts = messlogger.extractProtected(message)
	
	--api.Log:Err(cleanedMessage .." == ".. protectedParts)
	--api.Log:Err(cleanedMessage)
	
	-- Replace item link text with the item's name
	local count = 0
	while string.find(cleanedMessage, "|i") and count < 5 do -- fix this condition
		local beginIndex, _ = string.find(cleanedMessage, "|i")
		local _, endIndex = string.find(cleanedMessage, '0;')
		if beginIndex ~= nil and endIndex ~= nil then 
			local itemLinkText = string.sub(cleanedMessage, beginIndex, endIndex)
			local itemId = messlogger.itemIdFromItemLinkText(itemLinkText)
			local itemInfo = api.Item:GetItemInfoByType(tonumber(itemId))
			
			local beforeLink = string.sub(cleanedMessage, 0, beginIndex)
			local afterLink = string.sub(cleanedMessage, endIndex + 1, #cleanedMessage)
			--cleanedMessage = beforeLink .. "" .. itemInfo.name .. " " .. afterLink 
			cleanedMessage = beforeLink .. "[" .. itemInfo.name .. "] " .. afterLink 
		end 
		count = count + 1
	end 
	
	cleanedMessage = string.gsub(cleanedMessage, "%|", "")
	
	-- Тепер відновлюємо частини в квадратних дужках після перекладу
	cleanedMessage = messlogger.restoreProtected(cleanedMessage, protectedParts)
	
	--local endText = {chatMsg=tostring"||||"..(channel).."||||"..name.."||||"..cleanedMessage.."||||"}
	--api.File:Write(logFile.Name, endText)

	--local resultText = (name .. ": ".. cleanedMessage)
	--api.Log:Err("[WTB/WTS] " .. resultText)
	--api.Log:Info(endText)

	--return resultText
	return cleanedMessage

end

--messlogger.getData = function(filename)
function messlogger.getData(filename)
    local data = api.File:Read(filename)
    if data == nil then return {} end
    return data
end

--messlogger.getDate = function(timestamp)
function messlogger.getDate(timestamp)
    --local settings = helpers.getSettings()
    local timestamp = timestamp or api.Time:GetLocalTime()
	local timezone_offset = 0
    --local timezone_offset = settings.timezone_offset * 3600
	local timezone_offset = timezone_offset * 3600
    local localTimestamp = X2Util:StrNumericAdd(tostring(timestamp),
                                                tostring(timezone_offset))

    -- Количество секунд в сутках
    local secondsInADay = "86400"

    -- Вычисляем количество дней, прошедших с 1 января 1970
    local daysSinceEpoch = tonumber(X2Util:DivideNumberString(localTimestamp,
                                                              secondsInADay))
    -- Определяем год
    local year = 1970
    while daysSinceEpoch >= 365 do
        -- Проверяем високосный год
        local isLeapYear = (year % 4 == 0 and year % 100 ~= 0) or
                               (year % 400 == 0)
        local daysInYear = isLeapYear and 366 or 365

        -- Если дней хватает на целый год, вычитаем его
        if daysSinceEpoch >= daysInYear then
            daysSinceEpoch = tonumber(X2Util:StrNumericSub(tostring(
                                                               daysSinceEpoch),
                                                           tostring(daysInYear)))
            year = year + 1
        else
            break
        end
    end

    -- Определяем месяц и день
    local month = 1
    local daysInMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

    -- Учитываем високосные годы
    if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
        daysInMonth[2] = 29
    end

    while daysSinceEpoch >= daysInMonth[month] do
        daysSinceEpoch = tonumber(X2Util:StrNumericSub(tostring(daysSinceEpoch),
                                                       tostring(
                                                           daysInMonth[month])))
        month = month + 1
    end

    local day = X2Util:StrNumericAdd(tostring(daysSinceEpoch), "1") -- Дни считаются с 0, поэтому +1

    -- Вычисляем часы, минуты, секунды
    local fullDaysInSeconds = X2Util:StrIntegerMul(
                                  X2Util:DivideNumberString(localTimestamp,
                                                            secondsInADay),
                                  secondsInADay)
    local remainingSeconds = X2Util:StrNumericSub(localTimestamp,
                                                  fullDaysInSeconds)

    local hours = X2Util:DivideNumberString(remainingSeconds, "3600")
    local hoursInSeconds = X2Util:StrIntegerMul(hours, "3600")

    local minutes = X2Util:DivideNumberString(
                        X2Util:StrNumericSub(remainingSeconds, hoursInSeconds),
                        "60")
    local minutesInSeconds = X2Util:StrIntegerMul(minutes, "60")

    local seconds = X2Util:StrNumericSub(
                        X2Util:StrNumericSub(remainingSeconds, hoursInSeconds),
                        minutesInSeconds)

    local weekday = (tonumber(daysSinceEpoch) + 4) % 7

    -- Посчитаем день в году
    local dayOfYear = 0
    for m = 1, month - 1 do dayOfYear = dayOfYear + daysInMonth[m] end
    dayOfYear = dayOfYear + tonumber(day)

    -- Определяем день недели 1 января
    local jan1Weekday = (weekday - (dayOfYear % 7) + 7) % 7 -- День недели 1 января

    -- ISO-нумерация недель (первая неделя начинается с понедельника)
    local weekNumber = math.floor((dayOfYear + jan1Weekday - 1) / 7) + 1

    return {
        year = year,
        month = month,
        day = tonumber(day),
        hours = tonumber(hours),
        minutes = tonumber(minutes),
        seconds = tonumber(seconds),
        weekday = weekday,
        weekNumber = weekNumber, -- Номер недели
        dayOfYear = dayOfYear
    }
end



-- from Navigate
-- if event == "WORLD_MESSAGE" then openCoordsPromptFromWorldMessage(msg, iconKey, sextants, info) 
-- if event == "CHAT_MESSAGE" then if arg ~= nil then writeChatToTranslatingFile(channel, unit, isHostile, name, message, speakerInChatBound, specifyName, factionName, trialPosition)
--function messlogger.OnChatMessage(channelId, speakerId, _, speakerName, message)
function messlogger.OnChatMessage(channel, unit, isHostile, name, message, speakerInChatBound, specifyName, factionName, trialPosition)
--local function OnChatMessage(channel, unit, isHostile, name, message, speakerInChatBound, specifyName, factionName, trialPosition)

	

	if name ~= nil and #message > 2 then
		--api.Log:Info(name)
		
		--api.Log:Err(logFile.Name1 .. " and " ..logFile.Name2)
	
        -- Skip messages beginning with x and a space (looking for raid invites)
        if string.sub(message, 1, 1) == "x" and string.sub(message, 2, 2) == " " then return end  


		local resultText = {}
		
		--resultText.channel = channel -- 6 nation, 14 faction
		
		if channel == 6 then resultText.channel = "Nation"
		elseif channel == 14 then resultText.channel = "Faction"
		elseif channel == 1 then resultText.channel = "Shout"
		elseif channel == 0 then resultText.channel = "Local"
		elseif channel == 7 then resultText.channel = "Guild"
		else resultText.channel = channel
		end
		
		resultText.timestamp = api.Time:GetLocalTime()
		
		local date = messlogger.getDate(resultText.timestamp)

		resultText.time = string.format(
								'%02d.%02d.%d %02d:%02d',
								date.day, date.month, date.year, (date.hours + timeZone),
								date.minutes)

		resultText.name = name
		--resultText.rawmessage = message
		resultText.message = messlogger.prepareMessage(message)
		
		--api.Log:Err(resultText.message)
		--api.Log:Err(resultText.time .."|".. resultText.channel .."|".. resultText.name .."|".. resultText.message)

		if string.find(message, 'WTS', 1, true) or string.find(message, 'wts', 1, true) or string.find(message, 'WTT/S', 1, true) or string.find(message, 'WTTS', 1, true) then
			if logFile.data1.wts == nil then logFile.data1.wts = {} end
			if logFile.data2.wts == nil then logFile.data2.wts = {} end

			table.insert(logFile.data1.wts,  (resultText.time .."|".. resultText.channel .."|".. resultText.name .."|".. resultText.message))
			table.insert(logFile.data2.wts, resultText)

			api.File:Write(logFile.Name1, logFile.data1)
			api.File:Write(logFile.Name2, logFile.data2)
		end
		
		
		
		if string.find(message, 'WTB', 1, true) or string.find(message, 'wtb', 1, true) then
			if logFile.data1.wtb == nil then logFile.data1.wtb = {} end
			if logFile.data2.wtb == nil then logFile.data2.wtb = {} end

			table.insert(logFile.data1.wtb,  (resultText.time .."|".. resultText.channel .."|".. resultText.name .."|".. resultText.message))
			table.insert(logFile.data2.wtb, resultText)

			api.File:Write(logFile.Name1, logFile.data1)
			api.File:Write(logFile.Name2, logFile.data2)
		end
		
		if string.find(message, '16x16', 1, true) or
			string.find(message, '16 x 16', 1, true) or
			string.find(message, '24x24', 1, true) or
			string.find(message, '24 x 24', 1, true) or
			string.find(message, '48x48', 1, true) or			
			string.find(message, '48 x 48', 1, true) or
			string.find(message, 'house', 1, true) then
			if logFile.data1.land == nil then logFile.data1.land = {} end
			if logFile.data2.land == nil then logFile.data2.land = {} end

			table.insert(logFile.data1.land,  (resultText.time .."|".. resultText.channel .."|".. resultText.name .."|".. resultText.message))
			table.insert(logFile.data2.land, resultText)

			api.File:Write(logFile.Name1, logFile.data1)
			api.File:Write(logFile.Name2, logFile.data2)
		end

		
   end
end


local date = messlogger.getDate(api.Time:GetLocalTime())

date = string.format(
						'%02d.%02d.%d',
						date.year, date.month, date.day)

logFile.Name1 = 'wtb_wts/data/log_'..date..'.lua'
logFile.Name2 = 'wtb_wts/data/massiv_'..date..'.lua'

-- write in chat file names
--api.Log:Info(logFile.Name1 .. " and " ..logFile.Name2)

logFile.data1 = messlogger.getData(logFile.Name1)
logFile.data2 = messlogger.getData(logFile.Name2)

messlogger.data2 = logFile.data2

return messlogger