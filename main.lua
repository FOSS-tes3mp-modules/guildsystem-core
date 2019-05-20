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
	tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load options file: " .. guildsystem.core.optionsFile)
	if guildsystem.loadOptions() then
		tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Options loaded.")
		tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load guilds file: " .. guildsystem.options.files.guilds)
		if guildsystem.loadGuilds() then
			tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Guilds loaded.")
			tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load guilds submodules")

			guildsystem.loadSubmodules() -- submodules should report if they loaded correctly
		end
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

--- file methods
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