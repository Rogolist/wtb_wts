local ui = {}
--local messlogger = require('wtb_wts/messlogger') -- чтобы подписка на сообщения использовала функции

--local wtb_wtsWindow

--[[
ui.CreateMainWindow = function()

	ui.wtb_wtsWindow = api.Interface:CreateWindow("ui.wtb_wtsWindow", "WTB WTS addon")
	
	--ui.wtb_wtsWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	ui.wtb_wtsWindow:AddAnchor("TOPRIGHT", "UIParent", -200, 200)
	local windowSize = {600, 200}
	ui.wtb_wtsWindow:SetExtent(windowSize[1], windowSize[2])

end
]]

--[[
GetSavedItems = function(reverse)
    if reverse == nil then reverse = false end
    local savedData = api.File:Read(logFile.Name)
    return savedData or {}
end
]]

--function saveData(filename, data) api.File:Write(filename, data) end




--[[
local function OnUpdate()

	if message.delay == message.maxDelay then
		--local currentTime = parseTime(api.Time.GetLocalTime())
		
		api.Log:info(message.text)
	
		-- DispatchChatMessage(channel, message)
		X2Chat:DispatchChatMessage(1, message.text)
		X2Chat:DispatchChatMessage(2, message.text)
		X2Chat:DispatchChatMessage(3, message.text)
		
		--X2Chat:DispatchChatMessage(1, (currentTime .. message.text))
		--X2Chat:DispatchChatMessage(2, (currentTime .. message.text))
		--X2Chat:DispatchChatMessage(3, (currentTime .. message.text))

		message.delay = 0
	end

	if message.delay < message.maxDelay then
		message.delay = message.delay + 1
	end
	
	api.Log:info(message.delay)
end
]]

--[[
local clockTimer = 0
local clockResetTime = (60*1000)

--resultText.channel = channel -- 6 nation, 14 faction
local function OnUpdate(dt)
	if clockTimer + dt > clockResetTime then
		--api.Log:Info(message.text)
		--X2Chat:DispatchChatMessage(6, message.text)
		--X2Chat:DispatchChatMessage(14, message.text)
		--X2Chat:DispatchChatMessage("Local", message.text)
		
		for i=0,15 do
			local mess = tostring(i .. message.text)
			api.Log:Info(mess)
			X2Chat:DispatchChatMessage(i, mess)
		end
		
		clockTimer = 0
	end 
	clockTimer = clockTimer + dt
	--api.Log:Info(clockTimer)
end 
]]


-- поиск с фильтром по ...
--local function getList(author, searchText)
function getList(searchText)
    local listTable = {}

    --for id, name in pairs(doodadsHelper.names) do -- перебор из массива с ID и названиями объектов
        -- Check if the author matches or if author is nil or 1 (All)
        
	--logFile.data2.wts
	--for name, time, message, channel in pairs(logFile.data2.wts) do	
	--for mess = 1, #logFile.data2.wts do
	--	if (searchText == nil or searchText == "" or string.find(string.lower(mess.message), string.lower(searchText))) then -- поиск через соответствие имени и запроса


		
		--local doodadCategory = doodadsHelper.doodadsCategory[id] -- ID объекта к ID категории
        --if (author == nil or author == 1 or doodadCategory == author) then
            -- Check if searchText is nil or empty, or if it is found in the doodad's name
            --local doodadName = doodadsHelper:GetDoodadName(id) -- вернуть имя по ID (взятое перебором ???)
            --if (searchText == nil or searchText == "" or string.find(string.lower(doodadName), string.lower(searchText))) then -- поиск через соответствие имени и запроса
                --local doodadZones = doodadsHelper:GetDoodadZones(id)
                --local doodadEntry = {}
                --doodadEntry.text = doodadName
                --doodadEntry.opened = false
                --doodadEntry.child = {}
                --for _, zone in pairs(doodadZones) do
                --    local zoneName = doodadsHelper:GetDoodadZoneName(zone)
                --    local zoneEntry = {}
                --    zoneEntry.text = zoneName
                --    zoneEntry.value = id
                --    table.insert(doodadEntry.child, zoneEntry)
                --end

    --            table.insert(listTable, message)
    --        end
        --end
    --end
	
		table.insert(listTable, searchText)
    return listTable
end


function ui.mainWindow()
	local wtb_wtsWindow
	api.Log:Info("ui.mainWindow runned")

	--logFile.data = GetSavedItems()

    --ui.wtb_wtsWindow = api.Interface:CreateEmptyWindow("ui.wtb_wtsWindow", "UIParent")
	--ui.wtb_wtsWindow = api.Interface:CreateEmptyWindow("ui.wtb_wtsWindow", "WTB WTS addon")
	wtb_wtsWindow = api.Interface:CreateWindow("wtb_wtsWindow", "WTB WTS addon")
	
	--ui.wtb_wtsWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	wtb_wtsWindow:AddAnchor("TOPRIGHT", "UIParent", -200, 200)
	local windowSize = {600, 200}
	wtb_wtsWindow:SetExtent(windowSize[1], windowSize[2])

	-- подписка на сообщения чата
	--[[
    function ui.wtb_wtsWindow:OnEvent(event, ...)
        if event == "CHAT_MESSAGE" then
            if arg ~= nil then 
                --writeChatToTranslatingFile(unpack(arg))
				api.Log:Info("WTB/WTS: " .. unpack(arg))
				messlogger.OnChatMessage(unpack(arg))
				
            end 
        end 
    end
    ui.wtb_wtsWindow:SetHandler("OnEvent", ui.wtb_wtsWindow.OnEvent)
	--ui.wtb_wtsWindow:SetText("ui.wtb_wtsWindow")
    ui.wtb_wtsWindow:RegisterEvent("CHAT_MESSAGE")
	]]
	--api.Log:Err("Chat Event Registered")



	--[[
	-- выпадающий список результатов
	local resultList = W_CTRL.CreateScrollListBox("resultList", ui.wtb_wtsWindow)
	--local resultList =  api.Interface:CreateEmptyWindow("results", ui.wtb_wtsWindow) --just for test
	resultList:SetExtent(ui.wtb_wtsWindow:GetWidth() - 10 , ui.wtb_wtsWindow:GetHeight() - 80)
	resultList:AddAnchor("BOTTOMLEFT", ui.wtb_wtsWindow, -5, -10)	-- приаязка "TOPLEFT"
	
	resultList.content:UseChildStyle(true)
	resultList.content:EnableSelectParent(false)
	resultList.content:SetInset(5, 5, 8, 5)
	resultList.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
	resultList.content.childStyle:SetFontSize(FONT_SIZE.MIDDLE)
	resultList.content.itemStyle:SetAlign(ALIGN_LEFT)
	resultList.content:SetTreeTypeIndent(true, 20)
	resultList.content:SetHeight(FONT_SIZE.MIDDLE)
	resultList.content:ShowTooltip(true)
	--resultList:SetText("resultList")
	resultList.content:SetSubTextOffset(20, 0, true)
	local color = FONT_COLOR.TITLE
	resultList.content:SetDefaultItemTextColor(color[1], color[2], color[3], color[4])
	color = FONT_COLOR.DEFAULT
	resultList.content.childStyle:SetColor(color[1], color[2], color[3], color[4])
	
	-- наполнение
	--local listTable = getList() -- возвращает listTable с результатом поиска
	
	local listTable = {"test1", "test2"}
	resultList:SetItemTrees(listTable)
	]]

	--function resultList:OnSelChanged()
		--local selectedItem = resultList:GetSelectedIndex()
		--if index == 0 or index == -1 then return end 

		--local value = resultList:GetSelectedValue()
		--if value == 0 then return end
		-- api.Log:Info("Selected value: " .. tostring(value))
		-- Get the map path for the selected value
		--local id = value
		--local zone = doodadsHelper:GetDoodadZoneKey(resultList:GetSelectedText())
		
		-- запросить сстылку на файл изображения для -> dawnsdropMapWindow.mapDrawable:SetTexture(.....)
		--local mapDdsPath = doodadsHelper:GetDoodadZoneFilePath(id, zone)
		-- Set the map drawable to the new path
		--setSpawnMapImage(mapDdsPath)

	--end



	
	--ui.wtb_wtsWindow:Show(true)
	
	
	-- поиск по тексту
	-- Category dropdown and search text box 
	
	--local resultList = api.Interface:CreateComboBox(ui.wtb_wtsWindow)
	local resultList = W_CTRL.CreateScrollListBox("resultList", wtb_wtsWindow)
	--local resultList = api.Interface:CreateWidget('textbox', "resultList", ui.wtb_wtsWindow) --(type, id, parent)
    --resultListBtn:AddAnchor("TOPLEFT", ui.wtb_wtsWindow, 10, 50)
	resultList:AddAnchor("BOTTOMLEFT", wtb_wtsWindow, 5, -10)	-- приаязка "TOPLEFT"
    --resultListBtn:SetWidth(180)
	resultList:SetExtent(wtb_wtsWindow:GetWidth() - 10 , wtb_wtsWindow:GetHeight() - 80)
    --resultList.style:SetFontSize(FONT_SIZE.LARGE)
    --resultListBtn.dropdownItem = doodadCategories
	resultList.dropdownItem = {"test1", "test2"}
    --resultListBtn:Select(currentCategory)
	
	
	-- Doodad Name Search
	--local listTable = {}
    local searchTextEdit = W_CTRL.CreateEdit("searchTextEdit", ui.wtb_wtsWindow)
    searchTextEdit:SetExtent(wtb_wtsWindow:GetWidth()-40, 24)
	--searchTextEdit:SetExtent(ui.wtb_wtsWindow:GetWidth(), ui.wtb_wtsWindow:GetHeight() - 100)	
    searchTextEdit:AddAnchor("TOPLEFT", wtb_wtsWindow, 20, 30)	--"TOPLEFT" "TOPRIGHT"
    searchTextEdit.style:SetFontSize(FONT_SIZE.XLARGE)
    -- Doodad Name Search OnTextChanged
    function searchTextEdit:OnTextChanged()
        local searchText = searchTextEdit:GetText()
        if #searchText > 2 or #searchText == 0 then 
			-- запрос по категори и тексту
            --local listTable = getList(doodadCategoryBtn:GetSelectedIndex(), searchText)
			--api.Log:Info(searchText)
			local listTable = getList(searchText)
			--api.Log:Info(listTable)
			resultList:SetItemTrees(listTable) -- выпадающтй список массива с выбором
			
			--listTable = searchText
			--table.insert(listTable, searchText)
			--categoryList:SetItemTrees(listTable)
        end 
	end
	searchTextEdit:SetHandler("OnTextChanged", searchTextEdit.OnTextChanged)
	-- Doodad Category SelectedProc
    --function doodadCategoryBtn:SelectedProc()
    --    local listTable = getDoodadList(doodadCategoryBtn:GetSelectedIndex(), searchTextEdit:GetText())
	--	categoryList:SetItemTrees(listTable)
    --end 
	
	wtb_wtsWindow.listTable = listTable
	
	
	-- Create an overlay button (кнопка открытия окна аддона)
	--[[
	local overlayWnd = api.Interface:CreateEmptyWindow("overlayWnd", "UIParent") -- пустое окно для кнопки
	local overlayBtn = overlayWnd:CreateChildWidget("button", "overlayBtn", 0, true) -- сама кнопка
    ApplyButtonSkin(overlayBtn, BUTTON_BASIC.DEFAULT)
    overlayBtn:SetExtent(100, 32)
    overlayBtn:SetText("WTS WTB")
    overlayBtn.style:SetFontSize(13)
    overlayBtn:Show(true)
    overlayBtn:AddAnchor("TOPRIGHT", "UIParent", -450, 30)
    function overlayBtn:OnClick()
        local showWnd = not ui.wtb_wtsWindow:IsVisible()
        ui.wtb_wtsWindow:Show(showWnd)
    end 
    overlayBtn:SetHandler("OnClick", overlayBtn.OnClick) -- по клику появляется основное окно
	overlayWnd:Show(true)
    overlayWnd.overlayBtn = overlayBtn
	]]
	
	--ui.wtb_wtsWindow:Show(false)
	wtb_wtsWindow:Show(true)
	
	--ui.wtb_wtsWindow = wtb_wtsWindow
	
	
end

function ui.Unload()
	if ui.wtb_wtsWindow ~= nil then 
		ui.wtb_wtsWindow:Show(false)
		ui.wtb_wtsWindow:ReleaseHandler("OnEvent")
		ui.wtb_wtsWindow = nil
	end 
end

return ui