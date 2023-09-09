#include "script_component.hpp"
#include "config_lists.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"mti_main", "ace_interaction"};
        author = AUTHOR;
        authors[] = {"Kingsley", "Mokka"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "Cfg3DEN.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"

#include "MTI_Fortify_Presets.hpp"
#include "MTI_Fortify_Compositions.hpp"
