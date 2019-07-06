UsedVehicles = {}

UsedVehicles.SEND_NUM_BITS = 7 -- 2 ^ 7 = 128 max
--GuidanceSteering.MAX_NUM_TRACKS = 2 ^ GuidanceSteering.SEND_NUM_BITS
local directory = g_currentModDirectory
local modName = g_currentModName
local UsedVehicles_mt = Class(UsedVehicles)

function UsedVehicles:new(mission, modDirectory, modName, i18n, gui, inputManager, messageCenter, settingsModel)
    local self = {}
	Logger.info(modName..":****  In Used Vehicle:new ****")
    setmetatable(self, UsedVehicles_mt)

    self:mergeModTranslations(i18n)

    --self.isServer = mission:getIsServer()
    self.modDirectory = modDirectory
    self.modName = modName
    self.savedTracks = {}
    self.listeners = {}

    --self.ui = GuidanceSteeringUI:new(mission, i18n, modDirectory, gui, inputManager, messageCenter, settingsModel)

    return self
end


function UsedVehicles:mergeModTranslations(i18n)
    -- We can copy all our translations to the global table because we prefix everything with guidanceSteering_
    -- The mod-based l10n lookup only really works for vehicles, not UI and script mods.
    local global = getfenv(0).g_i18n.texts
    for key, text in pairs(i18n.texts) do
        global[key] = text
	end
end

 function UsedVehicles:getCategoryByName(name)
	if name ~= nil then
        Logger.info(modName..":  in GetCategoryByName using "..name:upper())
		return g_storeManager:getCategoryByName(name)
    end
    return nil
end

function UsedVehicles:onMissionLoadFromSavegame(xmlFile)
    local i = 0
    while true do
        local key = ("guidanceSteering.tracks.track(%d)"):format(i)
        if not hasXMLProperty(xmlFile, key) then
            break
        end

        local track = {}

        track.name = getXMLString(xmlFile, key .. "#name")
        track.strategy = getXMLInt(xmlFile, key .. "#strategy")
        track.method = getXMLInt(xmlFile, key .. "#method")

        track.guidanceData = {}
        track.guidanceData.width = MathUtil.round(getXMLFloat(xmlFile, key .. ".guidanceData#width"), 3)
        track.guidanceData.offsetWidth = MathUtil.round(getXMLFloat(xmlFile, key .. ".guidanceData#offsetWidth"), 3)
        track.guidanceData.snapDirection = { StringUtil.getVectorFromString(getXMLString(xmlFile, key .. ".guidanceData#snapDirection")) }
        track.guidanceData.driveTarget = { StringUtil.getVectorFromString(getXMLString(xmlFile, key .. ".guidanceData#driveTarget")) }

        ListUtil.addElementToList(self.savedTracks, track)

        i = i + 1
    end
end

function UsedVehicles:loadItemsToStore ()
    
    for _, item in ipairs(self.modStoreItems) do
        g_deferredLoadingManager:addSubtask(function()
            self:loadItem(item.xmlFilename, item.baseDir, item.customEnvironment, item.isMod, item.isBundleItem, item.dlcTitle)
        end)
    end;

    return true;
end;

function UsedVehicles:chooseEquipment ()
local storeItemsFilename = "dataS/storeItems.xml";
    if g_isPresentationVersionSpecialStore then
        storeItemsFilename = g_isPresentationVersionSpecialStorePath;
    end;
    self:loadItemsFromXML(storeItemsFilename);
    if xmlFile ~= nil then
        local mapStoreItemsFilename = getXMLString(xmlFile, "map.storeItems#filename");
        if mapStoreItemsFilename ~= nil then
            mapStoreItemsFilename = Utils.getFilename(mapStoreItemsFilename, baseDirectory);
            self:loadItemsFromXML(mapStoreItemsFilename);
        end;
    end;
end



