# guildsystem-core
The core for the guildsystem for tes3mp


## Should I use this?
No, currently this project is just a stub. Check back when I've made some more progress.


## How to install
1. clone this repository in your `server/scripts/custom/`:
```
git clone git@github.com:FOSS-tes3mp-modules/guildsystem-core.git guildsystem
```
4. add `require("custom/guildsystem/main")` to `server/scripts/customScripts.lua`
5. create `server/data/custom/guildsystem/`
6. success!

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
