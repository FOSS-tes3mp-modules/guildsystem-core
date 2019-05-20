guildsystem = {
	core = {
		optionsFile = "/custom/guildsystem/options.json",
		load = {},
		save = {}
	}
}

--- Loads options
-- loads options from file, returns true if loaded, false if not
-- @return boolean
function guildsystem.core.load.options()
	guildsystem.options = jsonInterface.load(guildsystem.core.optionsFile)
	return (guildsystem.options ~= nil)
end

--- Save options
-- saves options to file, returns true if loaded, false if not. (needed to allow server owner edit options on the fly
-- @return boolean
function guildsystem.core.save.options()
	return jsonInterface.save(guildsystem.core.optionsFile, guildsystem.options)
end

--- Loads guilds
-- loads guilds from file, returns true if loaded, false if not
-- @return boolean
function guildsystem.core.load.guilds()
	guildsystem.guilds = jsonInterface.load(guildsystem.options.files.guilds)
	return (guildsystem.guilds ~= nil)
end

--- Saves guilds
-- saves guilds to file, returns true if saved, false if not
-- @return boolean
function guildsystem.core.save.guilds()
	return jsonInterface.save(guildsystem.options.files.guilds, guildsystem.guilds)
end

--- Loads submodules
-- Load submodules from guildsystem.options.submodules
function guildsystem.load.submodules()
	for k, v in ipairs(guildsystem.options.submodules) do
		guildsystem.submodules[v] = require("../" .. v .. "/main")
	end
end

--- Init function
-- Starts the guild system and loads needed files for core
function guildsystem.core.init()
	tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load options file: " .. guildsystem.core.optionsFile)
	if guildsystem.core.load.options() then
		tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Options loaded.")
		tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load guilds file: " .. guildsystem.options.files.guilds)
		if guildsystem.core.load.guilds() then
			tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Guilds loaded.")
			tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load guilds submodules")

			guildsystem.load.submodules() -- submodules should report if they loaded correctly
		end
	end
end

--- filecheck
-- check if file exists, returns boolean
-- @string path
-- @return boolean
function guildsystem.core.fileCheck(path)
	local fh = io.open( path, "r" )
	if fh then
		io.close(fh)
		return true
	end
	return false
end

customEventHooks.registerHandler("OnServerPostInit", guildsystem.core.init)

return guildsystem
