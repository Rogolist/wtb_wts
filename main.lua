--local api = require("wtb_wts/api")
--local helpers = require('wtb_wts/helpers')
--local UI = require("Navigate/ui")

	local messlogger = require('wtb_wts/messlogger')
	--local ui = require('wtb_wts/ui')

local timeZone = 2
local wtb_wtsWindow
local resultList = {}
--local messlogger, ui, logFile = {}

-- нужно для файла-массива сохранять все предметы из сообщения в подмассив ?

local wtb_wts = {
    name = "wtb_wts",
    author = "Psejik",
    version = "0.0.6", -- добавить время сообщения, сохранять в виде массива: персонаж, время, предмет ?, сообщение
    desc = "Trade proposition logging"
}

--wtb_wts.Init = function() end

local function createResultList()
	
	-- выпадающий список результатов
	--[[
	resultList = W_CTRL.CreateScrollListBox("resultList", ui.wtb_wtsWindow)
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
	resultList = W_CTRL.CreateScrollListBox("resultList", wtb_wtsWindow)
	--local resultList = api.Interface:CreateWidget('textbox', "resultList", ui.wtb_wtsWindow) --(type, id, parent)
    --resultListBtn:AddAnchor("TOPLEFT", ui.wtb_wtsWindow, 10, 50)
	resultList:AddAnchor("BOTTOMLEFT", wtb_wtsWindow, 5, -10)	-- приаязка "TOPLEFT"
    --resultListBtn:SetWidth(180)
	resultList:SetExtent(wtb_wtsWindow:GetWidth() - 10 , wtb_wtsWindow:GetHeight() - 80)
    --resultList.style:SetFontSize(FONT_SIZE.LARGE)
    --resultListBtn.dropdownItem = doodadCategories
	--resultList.dropdownItem = {"test1", "test2"}
    --resultListBtn:Select(messlogger.data2)
	
	--categoryList:AddAnchor("TOPLEFT", dawnsdropMapWindow, 0, 90)	-- приаязка
	resultList.content:UseChildStyle(true)
	resultList.content:EnableSelectParent(false)
	resultList.content:SetInset(5, 5, 8, 5)
	resultList.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
	resultList.content.childStyle:SetFontSize(FONT_SIZE.MIDDLE)
	resultList.content.itemStyle:SetAlign(ALIGN_LEFT)
	resultList.content:SetTreeTypeIndent(true, 20)
	resultList.content:SetHeight(FONT_SIZE.MIDDLE)
	resultList.content:ShowTooltip(true)
	resultList.content:SetSubTextOffset(20, 0, true)
	local color = FONT_COLOR.TITLE
	resultList.content:SetDefaultItemTextColor(color[1], color[2], color[3], color[4])
	color = FONT_COLOR.DEFAULT
	resultList.content.childStyle:SetColor(color[1], color[2], color[3], color[4])
	
	
	local listTable = {{"34","57"},{1,2,3}}
	resultList:SetItemTrees(listTable)
	
	--wtb_wtsWindow.resultList = resultList
	--return resultList
end

local function mainWindow()
	
	--api.Log:Info("ui.mainWindow runned")

	--logFile.data = GetSavedItems()

    --ui.wtb_wtsWindow = api.Interface:CreateEmptyWindow("ui.wtb_wtsWindow", "UIParent")
	--ui.wtb_wtsWindow = api.Interface:CreateEmptyWindow("ui.wtb_wtsWindow", "WTB WTS addon")
	wtb_wtsWindow = api.Interface:CreateWindow("wtb_wtsWindow", "WTB WTS addon")
	
	--ui.wtb_wtsWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	wtb_wtsWindow:AddAnchor("TOPRIGHT", "UIParent", -200, 200)
	local windowSize = {600, 200}
	wtb_wtsWindow:SetExtent(windowSize[1], windowSize[2])


	--createResultList() -- действительно создает результирующий список !


	resultList = W_CTRL.CreateScrollListBox("resultList", wtb_wtsWindow)
	--local resultList = api.Interface:CreateWidget('textbox', "resultList", ui.wtb_wtsWindow) --(type, id, parent)
    --resultListBtn:AddAnchor("TOPLEFT", ui.wtb_wtsWindow, 10, 50)
	resultList:AddAnchor("BOTTOMLEFT", wtb_wtsWindow, 5, -10)	-- приаязка "TOPLEFT"
    --resultListBtn:SetWidth(180)
	resultList:SetExtent(wtb_wtsWindow:GetWidth() - 10 , wtb_wtsWindow:GetHeight() - 80)
    --resultList.style:SetFontSize(FONT_SIZE.LARGE)
    --resultListBtn.dropdownItem = doodadCategories
	--resultList.dropdownItem = {"test1", "test2"}
    --resultListBtn:Select(messlogger.data2)
	
	--categoryList:AddAnchor("TOPLEFT", dawnsdropMapWindow, 0, 90)	-- приаязка
	resultList.content:UseChildStyle(true)
	resultList.content:EnableSelectParent(false)
	resultList.content:SetInset(5, 5, 8, 5)
	resultList.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
	resultList.content.childStyle:SetFontSize(FONT_SIZE.MIDDLE)
	resultList.content.itemStyle:SetAlign(ALIGN_LEFT)
	resultList.content:SetTreeTypeIndent(true, 20)
	resultList.content:SetHeight(FONT_SIZE.MIDDLE)
	resultList.content:ShowTooltip(true)
	resultList.content:SetSubTextOffset(20, 0, true)
	local color = FONT_COLOR.TITLE
	resultList.content:SetDefaultItemTextColor(color[1], color[2], color[3], color[4])
	color = FONT_COLOR.DEFAULT
	resultList.content.childStyle:SetColor(color[1], color[2], color[3], color[4])
	
	
	local listTable = {{"34","57"},{1,2,3}}
	resultList:SetItemTrees(listTable)
	
	
	

	-- Doodad Name Search
	--local listTable = {}
    local searchTextEdit = W_CTRL.CreateEdit("searchTextEdit", wtb_wtsWindow)
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
			--local listTable = getList(searchText)
			--api.Log:Info(listTable)
			local listTable = {{searchText, searchText .. "12"},{1,2,3}}
			--api.Log:Info(listTable)
			
			resultList:SetItemTrees(listTable) -- выпадающтй список массива с выбором
			
			--listTable = searchText
			--table.insert(listTable, searchText)
			--categoryList:SetItemTrees(listTable)
		else
			--resultList:SetItemTrees({"","","",""})
			
        end 
	end
	searchTextEdit:SetHandler("OnTextChanged", searchTextEdit.OnTextChanged)
	-- Doodad Category SelectedProc
    --function doodadCategoryBtn:SelectedProc()
    --    local listTable = getDoodadList(doodadCategoryBtn:GetSelectedIndex(), searchTextEdit:GetText())
	--	categoryList:SetItemTrees(listTable)
    --end 
	
	wtb_wtsWindow.listTable = listTable
	--wtb_wtsWindow.resultList = createResultList()
	
	
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
	
	wtb_wtsWindow:Show(false)
	--wtb_wtsWindow:Show(true)

end

local function mainButton()

	-- Create an overlay button (кнопка открытия окна аддона)
	local overlayWnd = api.Interface:CreateEmptyWindow("overlayWnd", "UIParent") -- пустое окно для кнопки
	local overlayBtn = overlayWnd:CreateChildWidget("button", "overlayBtn", 0, true) -- сама кнопка
    ApplyButtonSkin(overlayBtn, BUTTON_BASIC.DEFAULT)
    overlayBtn:SetExtent(100, 32)
    overlayBtn:SetText("WTS WTB")
    overlayBtn.style:SetFontSize(13)
    overlayBtn:Show(true)
    overlayBtn:AddAnchor("TOPRIGHT", "UIParent", -450, 30)
    function overlayBtn:OnClick()
		--api.Log:Err("Test Click")
		--local wtb_wtsWindow = ui.wtb_wtsWindow
        local showWnd = not wtb_wtsWindow:IsVisible()
        wtb_wtsWindow:Show(showWnd)
    end 
    overlayBtn:SetHandler("OnClick", overlayBtn.OnClick) -- по клику появляется основное окно
	overlayWnd:Show(true)
    overlayWnd.overlayBtn = overlayBtn
	
	-- подписка на сообщения чата
    function overlayBtn:OnEvent(event, ...)
        if event == "CHAT_MESSAGE" then
            if arg ~= nil then 
                --writeChatToTranslatingFile(unpack(arg))
				--api.Log:Info("WTB/WTS: " .. unpack(arg))
				messlogger.OnChatMessage(unpack(arg))
				
            end 
        end 
    end
    overlayBtn:SetHandler("OnEvent", overlayBtn.OnEvent)
    overlayBtn:RegisterEvent("CHAT_MESSAGE")
	
end

-- from cant_read
local function OnLoad()

	--local messlogger = require('wtb_wts/messlogger')
	--local ui = require('wtb_wts/ui')

	--local logFile = {}

	--message.delay = 0
	--api.Log:Info(messlogger)

    api.Log:Info("Loaded " .. wtb_wts.name .. " v" ..
                     wtb_wts.version .. " by " .. wtb_wts.author)
	
    local settings = api.GetSettings("wtb_wts")
    --base64 = require('cant_read/base64/rfc')
	
	--if messlogger == nil then api.Log:Err("no messlogger") else

	--local date = getDate(api.Time:GetLocalTime())
	--[[
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
	]]
	
	mainButton()
	
	mainWindow()
	--ui.CreateMainWindow()
	
	if wtb_wtsWindow == nil then api.Log:Info("no wtb_wtsWindow") end

    api.On("UPDATE", OnUpdate)
    api.SaveSettings()
end


local function OnUnload()
	--api.On("UPDATE", function() return end)
	-- tier2SextantWindow = api.Interface:Free(tier2SextantWindow)

	--ui.Unload()

	if wtb_wtsWindow ~= nil then 
		wtb_wtsWindow:Show(false)
		wtb_wtsWindow = nil
	end 
	
	if overlayBtn ~= nil then 
		overlayBtn:Show(false)
		overlayBtn:ReleaseHandler("OnEvent")
		overlayBtn = nil
	end 
	
    api.On("UPDATE", function() return end)
    --wtb_wtsWindow:ReleaseHandler("OnEvent")
end



wtb_wts.OnLoad = OnLoad
wtb_wts.OnUnload = OnUnload
--wtb_wts.OnChatMessage = messlogger.OnChatMessage


--wtb_wts.OnChatMessage = OnChatMessage
--api.On("CHAT_MESSAGE", OnChatMessage)

return wtb_wts
