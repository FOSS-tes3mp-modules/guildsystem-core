-------
-- guildsystem
-- @module guildsystem
guildsystem = {}

--- options file (default: "/custom/guildsystem/options.json")
guildsystem.optionsFile = "/custom/guildsystem/options.json"
--- module version: 1
guildsystem.version = 1

--- Main method
-- @section main

--- Init function
-- Starts the guild system and loads needed files for core
function guildsystem.init()

	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Attempt to load options file")
	if not guildsystem.loadOptions() then
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Couldn't load options file, attempting to create it instead.")
		if not guildsystem.createOptionsFile() then
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Couldn't create options file: " .. guildsystem.optionsFile)
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Guildsystem will not be able to save, make sure that " .. guildsystem.optionsFile .. "'s directory is writable")
		else
			tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Created options file: " .. guildsystem.optionsFile)
		end
	else
		tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Loaded options file: " .. guildsystem.optionsFile)
	end

	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Checking version.")
	if guildsystem.version ~= guildsystem.options.version then
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Seems like options file is from older version, attempting to fix it.")
		if not guildsystem.updateVersion() then
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Couldn't fix version mismatch, will overwrite options file with new version based on script.")
			if not guildsystem.saveOptions() then
				tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Couldn't create options file: " .. guildsystem.optionsFile)
				tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Guildsystem will not be able to save, make sure that " .. guildsystem.optionsFile .. "'s directory is writable")
			else
				tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Saved version overwritten by script version")
			end
		else
			tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Version updated.")
		end
	else
		tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Version is up to date.")
	end

	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Attempting to load guilds file: " .. guildsystem.options.files.guilds)
	if not guildsystem.loadGuilds() then
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Couldn't load options file, attempting to create it instead.")
		if not guildsystem.createGuildsFile() then
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Couldn't create guilds file: " .. guildsystem.options.files.guilds)
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Guildsystem will not be able to save, make sure that " .. guildsystem.options.files.guilds .. "'s directory is writable")
		else
			tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] New guilds file created: " .. guildsystem.options.files.guilds)
		end
	else
		tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Loaded guilds file")
	end
	
	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Attempting to load submodules")
	if not guildsystem.loadSubmodules() then -- submodules should report if they loaded correctly
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Some modules could not be loaded")
	else
		tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] All modules loaded correctly.")
	end
end

--- Load functions
-- @section load

--- Loads options
-- loads options from file, returns true if loaded, false if not
-- @see guildsystem.optionsFile
-- @return boolean
function guildsystem.loadOptions()
	guildsystem.options = jsonInterface.load(guildsystem.optionsFile)
	return (guildsystem.options ~= nil)
end

--- Loads guilds
-- loads guilds from file, returns true if loaded, false if not
-- @return boolean
function guildsystem.loadGuilds()
	guildsystem.guilds = jsonInterface.load(guildsystem.options.files.guilds)
	return (guildsystem.guilds ~= nil)
end

--- Loads submodules
-- from guildsystem.options.submodules, returning boolean of success status
-- @return boolean
function guildsystem.loadSubmodules()
    if guildsystem.submodules == nil then
        guildsystem.submodules = {}
	end

	local goodLoad = true
	local submoduleCount = 1
	
	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Loaded submodules:")
	for k, v in pairs(guildsystem.options.submodules) do
		guildsystem.submodules[v] = prequire("custom/guildsystem/submodules/" .. v .. "/main")
		if guildsystem.submodules[v] then
			tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Module " .. submoduleCount .. ": " .. v .. " has been loaded.")
			submoduleCount = submoduleCount + 1
		else
			tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Module " .. v .. " could not be found.")
			goodLoad = false
		end
	end

	return goodLoad
end

---- Loads subdmodule
-- from guildsystem.options.submodules, returning boolean of success status
-- @return boolean
function guildsystem.loadSubmodule(moduleName)
	if moduleName == nil or moduleName == "" then
		return false
	end
	
	local isLoaded = false
	if package.loaded[moduleName] then
		isLoaded = true
	end


	if isLoaded then
		local modulePath = package.searchpath("custom/guildsystem/submodules/" .. moduleName .. "/main", package.path)
		guildsystem.subdmodules[moduleName] = dofile(modulePath)

		for key, value in pairs(package.loaded[modulePath]) do
			if guildsystem.subdmodules[moduleName] == nil then
				package.loaded[modulePath][key] = nil
			end
		end

		for key, value in pairs(result) do
			package.loaded[modulePath][key] = value
		end
	else
		guildsystem.subdmodules[moduleName] = prequire(scriptName)
	end
end

--- Save functions
-- @section save

--- Save options
-- saves options to file, returns true if loaded, false if not. (needed to allow server owner edit options on the fly)
-- @return boolean
function guildsystem.saveOptions()
	return jsonInterface.save(guildsystem.optionsFile, guildsystem.options)
end

--- Saves guilds
-- saves guilds to file, returns true if saved, false if not
-- @return boolean
function guildsystem.saveGuilds()
	return jsonInterface.save(guildsystem.options.files.guilds, guildsystem.guilds)
end

--- Create functions
-- @section create

--- Create config file if there isn't one, returning boolean of success status
-- @return boolean
function guildsystem.createOptionsFile()
	guildsystem.options = {
		files = {
			guilds = "/custom/guildsystem/guilds.json"
		},
		version = 1,
		submodules = {},
		guildCreation = {
			cost = false,
			item = "gold_001",
			amount = 50,
			blacklist = {},
			guildFormat = {
				members = {},
				ranks = {},
				guildRankToDeleteGuild = 10
			}
		},
		serverRankToDeleteGuild = 3,
		guildRankToDeleteGuild = 10,
		serverWideGuildRankToDelete = true
	}
	return guildsystem.saveOptions()
end

--- Create guilds file if there isn't one,  returning boolean of success status
-- @return boolean
function guildsystem.createGuildsFile()
	guildsystem.guilds = {}
	return guildsystem.saveGuilds()
end

--- Create guild returning boolean of success status
-- @return boolean
-- @param pid player ID
-- @string guildName guild name
function guildsystem.createGuild(pid, guildName)
	
	-- @todo Properly filter guildName
	if guildName == nil or guildName == "" then
		return false
	end

	-- Player already in guild
	if Players[pid].guildName ~= nil then
		return false
	end

	-- Guild already exists
	if guildsystem.guilds[guildName] ~= nil then
		return false	
	end

	-- Check (case-insensitive) if guildName is in blacklist
	for k, v in pairs(guildsystem.options.guildCreation.blacklist) do
		if guildName:ciEqual(v) then
			return false
		end
	end

	-- @todo Add subroutine to check for cost 
	--[[
	-- Check if player has currency in inventory
	if guildsystem.guildCreation.cost then
		
	end
	--]]

	guildsystem.guilds[guildName] = guildsystem.options.guildCreation.guildFormat
	guildsystem.guilds[guildName].members[Players[pid].data.login.name] = 10

	if guildsystem.saveGuilds() then
		Players[pid].guild = {
			[guildName] = guildsystem.guilds[guildName].members[Players[pid].data.login.name]
		}
		-- Actually remove currency from inventory
		if guildsystem.guildCreation.cost then

		end
		return true
	else
		guildsystem.guilds[guildName] = nil
		return false
	end
end

--- Update functions
-- @section update

--- Update version, returning boolean of success status
-- @return boolean
function guildsystem.updateVersion()
	local update = false
	local scriptVersion = true
	local optionsVersion = true

	if guildsystem.options.version == nil or guildsystem.options.version == 0 or type(guildsystem.options.version) ~= "number" then
		optionsVersion = false
	end

	if guildsystem.version == nil or guildsystem.version == 0 or type(guildsystem.version) ~= "number" then
		scriptVersion = false
	end

	if not scriptVersion and not optionsVersion then
		update = false
	elseif not scriptVersion and optionsVersion then
		guildsystem.version = guildsystem.options.version
	elseif scriptVersion and not optionsVersion then
		guildsystem.options.version = guildsystem.version
	end

	-- For future updates
	if scriptVersion == 1 then
		if optionsVersion == 2 then

		end
	end
	
	if update then
		return guildsystem.saveOptions()
	end
	return false
end

--- Delete functions
-- @section delete

--- Delete guild
-- check if allowed to delete guild
-- @param pid
-- @string guildName
function guildsystem.deleteGuild(pid, guildName)

	-- @todo Properly filter guildName
	if guildName == nil or guildName == "" then
		return false
	end
	-- Guild already exists
	if guildsystem.guilds[guildName] == nil then
		return false
	end
		
	local allowed = false
	local rankNeeded = guildsystem.options.serv
	if guildsystem.options.serverWideGuildRankToDelete then
		rankNeeded = guildsystem.options.guildRankToDeleteGuild
	else
		rankNeeded = guildsystem.guilds[guildName].guildRankToDeleteGuild
	end

	-- check if player server rank is high enough to delete guild
	if Players[pid].data.settings.staffRank >= guildsystem.options.serverRankToDeleteGuild then
		allowed = true
	end

	-- check if player guild rank is high enough to delete guild
	if Players[pid].guild ~= nil then
		if Players[pid].guild[guildName] ~= nil then
			if Players[pid].guild[guildName] >= rankNeeded then
				allowed = true
			end
		end
	end

	if not allowed then
		return false
	else
		guildsystem.guilds[guildName] = nil
		for pID, t in ipairs(Players) do
			Players[pID].guild[guildName] = nil
		end
		return true
	end
end

--- File functions
-- @section file

--- filecheck
-- check if file exists, returns boolean
-- @string path
-- @return boolean
function guildsystem.fileCheck(path)
	local fh = io.open( path, "r" )
	if fh then
		io.close(fh)
		return true
	end
	return false
end


customEventHooks.registerHandler("OnServerPostInit", guildsystem.init)

return guildsystem