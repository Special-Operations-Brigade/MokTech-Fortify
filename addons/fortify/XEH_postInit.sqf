#include "script_component.hpp"

if (isServer) then {
    [QGVAR(objectPlaced), {_this call FUNC(objectPlaced)}] call CBA_fnc_addEventHandler;

    [QGVAR(compositionPlaced), {_this call FUNC(compositionPlaced)}] call CBA_fnc_addEventHandler;
};

if (!hasInterface) exitWith {};

GVAR(isPlacing) = PLACE_CANCEL;
["ace_interactMenuOpened", {GVAR(isPlacing) = PLACE_CANCEL}] call CBA_fnc_addEventHandler;

// Add actions to save containers automatically
["ace_interactMenuOpened", {_this call FUNC(interaction_addSaveActions)}] call CBA_fnc_addEventHandler;

// Add actions to composition containers automatically
["ace_interactMenuOpened", {_this call FUNC(interaction_addCompositionActions)}] call CBA_fnc_addEventHandler;

GVAR(objectRotationX) = 0;
GVAR(objectRotationY) = 0;
GVAR(objectRotationZ) = 0;
GVAR(distanceOffset) = 0;

// Register CBA Chat command for admins (Example: #mti-fortify on)
["mti-fortify", LINKFUNC(handleChatCommand), "admin"] call CBA_fnc_registerChatCommand;

[QGVAR(addActionToObject), {_this call FUNC(addActionToObject)}] call CBA_fnc_addEventHandler;

// addAction
[QGVAR(ace_addActionToObject), {_this call ACE_interact_menu_fnc_addActionToObject}] call CBA_fnc_addEventHandler;

// Place object event handler
[QGVAR(deployFinished), {_this call FUNC(deployFinished)}] call CBA_fnc_addEventHandler;

[QGVAR(deployCanceled), {_this call FUNC(deployCanceled)}] call CBA_fnc_addEventHandler;

// Place composition event handler
[QGVAR(compositionDeployFinished), {_this call FUNC(compositionDeployFinished)}] call CBA_fnc_addEventHandler;

[QGVAR(compositionDeployCanceled), {_this call FUNC(compositionDeployCanceled)}] call CBA_fnc_addEventHandler;

// Add "medical facility" post-deploy handler by default
GVAR(postDeployHandlers) pushBack (FUNC(postDeploy_medicalFacility));

// Add event to forcefully flush the cache
[QGVAR(flushCache), {
    params ["_container"];
    GVAR(availablePresetsCache) = [];
    GVAR(containerPresetsHashmap) set [typeOf _container, nil];
}] call CBA_fnc_addEventHandler;
