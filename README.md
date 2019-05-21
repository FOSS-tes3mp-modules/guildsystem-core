# guildsystem-core
The core for an guildsystem for tes3mp


## Should I use this?
Not yet, there is still some work to be done and tested.

### Tested (It works on my machine!)
- Config loading
- Submodule loading

### Untested
- Creating an guild
- Deleting an guild

### Uncoded
- Leaving an guild
- (custom) ranks
- Proper version -> new version updating
- data structures for guilds
- Chat/GUI handler (might shoot this off to another module)
- Hooks system (hooks for creating/leaving a guild etc.. so submodules can change default action of core)

## How to install
1. clone this repository in your `server/scripts/custom/`:
```
git clone git@github.com:FOSS-tes3mp-modules/guildsystem-core.git guildsystem
```
4. add `require("custom/guildsystem/main")` to `server/scripts/customScripts.lua`
5. create `server/data/custom/guildsystem/`
6. success!

## Docs
[guildsystem core](https://foss-tes3mp-modules.github.io/guildsystem-core/ "guildsystem core")

### How to generate the docs
Want to update your local docs because you added something?
1. Install [LDOC](https://github.com/stevedonovan/ldoc "github")
2. CD to `server/scripts/custom/guildsystem/`
3. Execute `ldoc .`
4. Open `server/scripts/custom/guildsystem/doc/index.html` in your browser

## How to install an submodule
1. clone the repository in your `server/scripts/custom/guildsystem`
```
git clone git@github.com:FOSS-tes3mp-modules/guildsystem-%submodule-name%.git %submodule-name%
```
2. Add it to the submodules section in `server/data/custom/guildsystem/options.json`:
```json
{
  "submodules" : [
    "%submodule-name%"
  ]
}
```

## Submodule list
None yet.

### Planned submodules
1. Guild banking
2. Guild chat system
3. Guild/Party info (Might split this off to it's own module instead of submodule)
4. Guild housing system
5. Guild territory system
