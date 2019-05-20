guildsystem = {
	core = {},
	plugins = {},
	config = {
		files = {
			guilds = "/custom/guildsystem/guilds.json",
			options = "/custom/guildsystem/options.json"
		}
	}
}


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

--- Loads guilds
-- loads guilds from file, returns true if loaded, false if not
-- @return boolean
function guildsystem.core.load.guilds()
	guildsystem.guilds = jsonInterface.load(guildsystem.config.files.guilds)
	return (guildsystem.guilds ~= nil)
end

--- Saves guilds
-- saves guilds to file, returns true if saved, false if not
-- @return boolean
function guildsystem.core.save.guilds()
	return jsonInterface.save(guildsystem.config.files.guilds)
end

--- Loads options
-- loads options from file, returns true if loaded, false if not
-- @return boolean
function guildsystem.core.load.options()
	guildsystem.options = jsonInterface.load(guildsystem.config.files.options)
	return (guildsystem.options ~= nil)
end

--- Save options
-- saves options to file, returns true if loaded, false if not. (needed to allow server owner edit options on the fly
-- @return boolean
function guildsystem.core.save.options()
	return jsonInterface.save(guildsystem.config.files.options)
end


--- Init function
-- Starts the guild system and loads needed files for core
function guildsystem.core.init()
	tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load options file: " .. guildsystem.core.files.options)
	if guildsystem.core.load.options() then
		tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Options loaded.")
	end
	tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Attempting to load guilds file: " .. guildsystem.core.files.guilds)
	if guildsystem.core.load.guilds() then
		tes3mp.LogMessage(enumerations.log.INFO, "[guilds] Guilds loaded.")
	end

end



customEventHooks.registerHandler("OnServerPostInit", guildsystem.core.init)

return guildsystem
