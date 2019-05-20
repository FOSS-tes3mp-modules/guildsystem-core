-------
-- guildsystem
-- @module guildsystem
guildsystem = {}

--- options file
guildsystem.optionsFile = "/custom/guildsystem/options.json"
--- module version: 0.1
guildsystem.version = '0.1'

--- Main method
-- @section main

--- Init function
-- Starts the guild system and loads needed files for core
function guildsystem.init()

	tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Attempt to load options file")
	if !guildsystem.loadOptions() then
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Couldn't load options file, attempting to create it instead.")
		if !guildsystem.createOptionsFile() then
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Couldn't create options file: " .. guildsystem.optionsFile)
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Guildsystem will not be able to save, make sure that " .. guildsystem.optionsFile .. "'s directory is writable")
		else
			tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Created options file: " .. guildsystem.optionsFile)
		end
	else
		tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Loaded options file: " .. guildsystem.optionsFile)
	end

	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Checking versions.")
	if guildsystem.version ~= guildsystem.options.version then
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Seems like options file is from older version, attempting to fix it.")
		if !guildsystem.updateVersion() then
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Couldn't fix version mismatch, will overwrite options file with new version based on script.")
			if !guildsystem.saveOptions() then
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
	if !guildsystem.loadGuilds() then
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Couldn't load options file, attempting to create it instead.")
		if !guildsystem.createGuildsFile() then
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Couldn't create guilds file: " .. guildsystem.options.files.guilds)
			tes3mp.LogMessage(enumerations.log.ERROR, "[guildsystem] Guildsystem will not be able to save, make sure that " .. guildsystem.options.files.guilds .. "'s directory is writable")
		else
			tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] New guildas file created: " .. guildsystem.options.files.guilds)
		end
	else
		tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Loaded guilds file")
	end
	
	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Attempting to load guilds submodules")
	if !guildsystem.loadSubmodules() then -- submodules should report if they loaded correctly
		tes3mp.LogMessage(enumerations.log.WARN, "[guildsystem] Some modules could not be loaded")
	end
	tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] Loaded submodules:")
	local submoduleCount = 1
	for k, v in ipairs(guildsystem.submodules) do
		tes3mp.LogMessage(enumerations.log.INFO, "[guildsystem] " .. submoduleCount .. ": " .. k)
		submoduleCount++
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
-- Load submodules from guildsystem.options.submodules
function guildsystem.loadSubmodules()
    if guildsystem.submodules == nil then
        guildsystem.submodules = {}
    end
	for k, v in ipairs(guildsystem.options.submodules) do
		guildsystem.submodules[v] = require("../" .. v .. "/main")
	end
end

--- Save functions
-- @section save

--- Save options
-- saves options to file, returns true if loaded, false if not. (needed to allow server owner edit options on the fly
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
		version = '0.1'
	}
	return guildsystem.saveOptions()
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