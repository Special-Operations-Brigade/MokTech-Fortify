#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Init array of build locations at preinit
// Can add anything that would work in inArea (triggers, markers or array format [center, a, b, angle, isRectangle, c])
GVAR(locations) = [];

// Custom deploy handlers
GVAR(deployHandlers) = [];
GVAR(postDeployHandlers) = [];

// Default list of medical facilities by classname
GVAR(medicalFacilities) = ["3AS_Tent_Med"];

// Global hashmap for containers and their assigned presets, used for caching
GVAR(containerPresetsHashmap) = createHashMap;

// Caching variable for nearby containers (and presets)
GVAR(availablePresetsCache) = [];

#include "initSettings.sqf"

ADDON = true;
