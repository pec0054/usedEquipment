

local directory = g_currentModDirectory
local modName = g_currentModName
source(Utils.getFilename("src/Logger.lua", directory))
source(Utils.getFilename("src/UsedVehicles.lua", directory))

local usedVehicles

local function isEnabled()
    return usedVehicles ~= nil
end

function init()
     FSBaseMission.delete = Utils.appendedFunction(FSBaseMission.delete, unload)

     Mission00.load = Utils.prependedFunction(Mission00.load, loadMission)
     Mission00.loadMission00Finished = Utils.appendedFunction(Mission00.loadMission00Finished, loadedMission)

     FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, saveToXMLFile)
	 StoreManager.loadMapData = Utils.prependedFunction(StoreManager.loadMapData, loadMapData)

    -- -- Networking
    -- SavegameSettingsEvent.readStream = Utils.appendedFunction(SavegameSettingsEvent.readStream, readStream)
    -- SavegameSettingsEvent.writeStream = Utils.appendedFunction(SavegameSettingsEvent.writeStream, writeStream)

    --VehicleTypeManager.validateVehicleTypes = Utils.prependedFunction(VehicleTypeManager.validateVehicleTypes, validateVehicleTypes)
    --StoreItemUtil.getConfigurationsFromXML = Utils.overwrittenFunction(StoreItemUtil.getConfigurationsFromXML, addGPSConfigurationUtil)
	--result_table = g_storeManager.getCategoryByName("VEHICLE")
	Logger.info(modName..":  Used Vehicles Mod Init")
	--getCategoryList()
		local name = "usedTractors"
		local title = "Used Tractors"
		local imageFilename = Utils.getFilename("resources/usedVehicles.dds", directory)
		local type = "VEHICLE"
	
       --g_storeManager.categories[name] = category
		g_storeManager:addCategory(name, title, imageFilename, type, "")

	
-- g_currentMission.inGameMessage:showDialog("TITle", self); ??

--if not g_currentMission.inGameMessage:getIsVisible() and not g_gui:getIsGuiVisible() then
end

 function unload()
	 Logger.info(modName..":  Unload function called")
 end

 function loadMission()
	Logger.info(modName..":  loadMission called")
	assert(g_usedVehicles == nil)

    usedVehicles = UsedVehicles:new(mission, directory, modName, g_i18n, g_gui, g_gui.inputManager, g_messageCenter, g_settingsScreen.settingsModel)

    getfenv(0)["g_usedVehicles"] = usedVehicles

    addModEventListener(usedVehicles)
	-- --```g_currentMission.inGameMessage:showMessage("TITle", "Some text", -1); --TourIcons
 end
 

function getTableLength(obj)
    local c = 0
    for _ in pairs(obj) do c = c + 1 end
    return c
end


 function saveToXMLFile(missionInfo)
     if not isEnabled() then
         return
     end

    if missionInfo.isValid then
        local xmlFile = createXMLFile("UsedVehicleXML", missionInfo.savegameDirectory .. "/usedVehicles.xml", "usedVehicle")
        if xmlFile ~= nil then
        usedVehicle:onMissionSaveToSavegame(xmlFile)

        saveXMLFile(xmlFile)
        delete(xmlFile)
        end
    end
 end




 function loadedMission(mission, node)
    if not isEnabled() then
        return
    end
	Logger.info(modName..":  loadedMission called")
			if g_storeManager.categories ~= nil then
			for k,cats in pairs(g_storeManager.categories) do 
				print("Cat Name "..cats.name.." Cat type "..cats.type.." Cat Title "..cats.title.." cats.imageFileName"..cats.image.." cat order "..cats.orderId)
			end
		end	
    -- if mission:getIsServer() then
        -- if mission.missionInfo.savegameDirectory ~= nil and fileExists(mission.missionInfo.savegameDirectory .. "/guidanceSteering.xml") then
            -- local xmlFile = loadXMLFile("GuidanceXML", mission.missionInfo.savegameDirectory .. "/guidanceSteering.xml")
            -- if xmlFile ~= nil then
                -- guidanceSteering:onMissionLoadFromSavegame(xmlFile)
                -- delete(xmlFile)
            -- end
        -- end
    -- end

    -- if mission.cancelLoading then
        -- return
    -- end

    -- guidanceSteering:onMissionLoaded(mission)
end


function loadMapData(xmlFile, missionInfo, baseDirectory)
	Logger.info(modName..":  LoadMapData called")
	numOfCategories = 1
		if g_storeManager.categories ~= nil then
			for k,cats in pairs(g_storeManager.categories) do 
				numOfCategories = numOfCategories + 1
			end
		end
		--g_storeManager:update()
	
	-- g_deferredLoadingManager:addSubtask(function()
		-- local newName = "usedTractors"
		-- local newTitle = "Used Tractors"
		-- local imageFilename = "$data/vehicles/newHolland/T5/store_T5.png" 
		-- local type = "VEHICLE"
		-- g_storeManager:addCategory(newName, newTitle, imageFilename, type, "")
		-- print("after add category")
	-- end)
		if g_storeManager.categories ~= nil then
			for k,cats in pairs(g_storeManager.categories) do 
				print("Cat Name "..cats.name.." Cat type "..cats.type)
			end
		end	
end

init()