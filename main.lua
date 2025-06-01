local api = require("api")
local helpers = require('wtb_wts/helpers')

local logFile = {}
logFile.Name1 = 'wtb_wts/log.lua'
logFile.Name2 = 'wtb_wts/massiv.lua'

local timeZone = 2

--[[
	Альфа вариант:
	1) мониторим чат
	2) находим ключевое слово
	3) выводим сообщение в системный лог
]]

--[[
	Бета вариант
	1) открываем файл записи
	2) следим за сообщениями в чатах
	3) если попадается ключевое слово - пишем в файл

]]

local wtb_wts = {
    name = "wtb_wts",
    author = "Psejik",
    version = "0.0.3b", -- добавить время сообщения, сохранять в виде массива: персонаж, время, предмет, сообщение
    desc = "Trade proposition logging"
}

local wtb_wtsWindow


function getData(filename)
    local data = api.File:Read(filename)
    if data == nil then return {} end
    return data
end

--[[
GetSavedItems = function(reverse)
    if reverse == nil then reverse = false end
    local savedData = api.File:Read(logFile.Name)
    return savedData or {}
end
]]

--function saveData(filename, data) api.File:Write(filename, data) end



local function split(s, sep)
    local fields = {}
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

local function itemIdFromItemLinkText(itemLinkText)
    local itemIdStr = string.sub(itemLinkText, 3)
    itemIdStr = split(itemIdStr, ",")
    itemIdStr = itemIdStr[1]
    return itemIdStr
end 

-- Функція для витягування та заміни частин тексту в квадратних дужках
local function extractProtected(text)
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
local function restoreProtected(text, protected)
    for i, block in ipairs(protected) do
        text = text:gsub(string.format("%[%[TOKEN_%d%]%]", i), block)
    end
    return text
end


-- магия над мессаджем )
local function prepareMessage(message)

	-- Заміняємо частини в квадратних дужках на тимчасові токени
	local cleanedMessage, protectedParts = extractProtected(message)
	
	--api.Log:Err(cleanedMessage .." == ".. protectedParts)
	--api.Log:Err(cleanedMessage)
	
	-- Replace item link text with the item's name
	local count = 0
	while string.find(cleanedMessage, "|i") and count < 5 do -- fix this condition
		local beginIndex, _ = string.find(cleanedMessage, "|i")
		local _, endIndex = string.find(cleanedMessage, '0;')
		if beginIndex ~= nil and endIndex ~= nil then 
			local itemLinkText = string.sub(cleanedMessage, beginIndex, endIndex)
			local itemId = itemIdFromItemLinkText(itemLinkText)
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
	cleanedMessage = restoreProtected(cleanedMessage, protectedParts)
	
	--local endText = {chatMsg=tostring"||||"..(channel).."||||"..name.."||||"..cleanedMessage.."||||"}
	--api.File:Write(logFile.Name, endText)

	--local resultText = (name .. ": ".. cleanedMessage)
	--api.Log:Err("[WTB/WTS] " .. resultText)
	--api.Log:Info(endText)

	--return resultText
	return cleanedMessage

end

-- from Navigate
-- if event == "WORLD_MESSAGE" then openCoordsPromptFromWorldMessage(msg, iconKey, sextants, info) 
-- if event == "CHAT_MESSAGE" then if arg ~= nil then writeChatToTranslatingFile(channel, unit, isHostile, name, message, speakerInChatBound, specifyName, factionName, trialPosition)
--local function OnChatMessage(channelId, speakerId, _, speakerName, message)
local function OnChatMessage(channel, unit, isHostile, name, message, speakerInChatBound, specifyName, factionName, trialPosition)

	if name ~= nil and #message > 2 then
        -- Skip messages beginning with x and a space (looking for raid invites)
        if string.sub(message, 1, 1) == "x" and string.sub(message, 2, 2) == " " then return end  



		if string.find(message, 'WTS', 1, true) or string.find(message, 'wts', 1, true) or string.find(message, 'WTT/S', 1, true) or string.find(message, 'WTTS', 1, true) then
			if logFile.data1.wts == nil then logFile.data1.wts = {} end
			if logFile.data2.wts == nil then logFile.data2.wts = {} end
			
			local resultText = {}
			
			
			resultText.timestamp = api.Time:GetLocalTime()
			
            local date = helpers.getDate(resultText.timestamp)

			resultText.time = string.format(
                                    '%02d.%02d.%d %02d:%02d',
                                    date.day, date.month, date.year, (date.hours + timeZone),
                                    date.minutes)
			
			
			resultText.name = name
			--resultText.rawmessage = message
			resultText.message = prepareMessage(message)

				--api.Log:Err(resultText.message)

			table.insert(logFile.data1.wts,  (resultText.time .."|".. resultText.name .."|".. resultText.message))
			--saveData(logFile.data1)
			
				api.Log:Info(resultText.time .." ".. resultText.name .." ".. resultText.message)
			
			table.insert(logFile.data2.wts, resultText)
			--api.Log:Info(logFile.data.wts)
			--saveData(logFile.data2)
			
			api.File:Write(logFile.Name1, logFile.data1)
			api.File:Write(logFile.Name2, logFile.data2)
		end
		
		
		
		if string.find(message, 'WTB', 1, true) or string.find(message, 'wtb', 1, true) then
			if logFile.data1.wtb == nil then logFile.data1.wtb = {} end
			if logFile.data2.wtb == nil then logFile.data2.wtb = {} end
			
			local resultText = {}
			resultText.time = api.Time:GetLocalTime()
			resultText.name = name
			--resultText.rawmessage = message
			resultText.message = prepareMessage(message)
			--resultText.items = resultText.message

				--api.Log:Err(resultText.message)

			table.insert(logFile.data1.wtb,  (resultText.time .."|".. resultText.name .."|".. resultText.message))
			
				api.Log:Info(resultText.time .." ".. resultText.name .." ".. resultText.message)
				
			table.insert(logFile.data2.wtb, resultText)
			--api.Log:Info(logFile.data.wtb)
			
			api.File:Write(logFile.Name1, logFile.data1)
			api.File:Write(logFile.Name2, logFile.data2)
		end
   end
end

-- from cant_read
local function OnLoad()

    api.Log:Info("Loaded " .. wtb_wts.name .. " v" ..
                     wtb_wts.version .. " by " .. wtb_wts.author)
	
    local settings = api.GetSettings("wtb_wts")
    --base64 = require('cant_read/base64/rfc')

	logFile.data1 = getData(logFile.Name1)
	logFile.data2 = getData(logFile.Name2)
	
	--logFile.data = GetSavedItems()

    wtb_wtsWindow = api.Interface:CreateEmptyWindow("wtb_wtsWindow", "UIParent")

    function wtb_wtsWindow:OnEvent(event, ...)
        if event == "CHAT_MESSAGE" then
            if arg ~= nil then 
                --writeChatToTranslatingFile(unpack(arg))
				--api.Log:Info("WTB/WTS: " .. unpack(arg))
				OnChatMessage(unpack(arg))
				
            end 
        end 
    end
    wtb_wtsWindow:SetHandler("OnEvent", wtb_wtsWindow.OnEvent)
    wtb_wtsWindow:RegisterEvent("CHAT_MESSAGE")

    api.On("UPDATE", OnUpdate)
    api.SaveSettings()
end


local function OnUnload()
	--api.On("UPDATE", function() return end)
	-- tier2SextantWindow = api.Interface:Free(tier2SextantWindow)
	--[[
	if wtb_wtsWindow ~= nil then 
		--tier2SextantWindow:Show(false)
		wtb_wtsWindow:ReleaseHandler("OnEvent")
		wtb_wtsWindow = nil
	end 
	]]
	
    api.On("UPDATE", function() return end)
    wtb_wtsWindow:ReleaseHandler("OnEvent")
end



wtb_wts.OnLoad = OnLoad
wtb_wts.OnUnload = OnUnload

--wtb_wts.OnChatMessage = OnChatMessage
--api.On("CHAT_MESSAGE", OnChatMessage)

return wtb_wts
