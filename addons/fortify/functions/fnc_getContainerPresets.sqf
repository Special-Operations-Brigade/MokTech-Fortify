#include "script_component.hpp"

/*
Function: mti_fortify_fnc_getContainerPresets

Description:
    Returns a hashmap of all the given containers presets and the attached budget.

Arguments:
    _container - Container to return presets for (object or class name)

Return Value:
    Hashmap with container's presets as key and budgets as values

Example:
    (begin example)
        [cursorTarget] call mti_fortify_fnc_getContainerPresets;
    (end)

Author:
	Mokka
*/

params ["_container"];

if(_container isEqualTo ACE_player) then {
    _container = backpack _container;
};

private ["_containerPresets"];
if (_container isEqualType objNull) then {
    _containerPresets = _container getVariable QGVAR(availablePresets);
    _container = typeOf _container;
};

private _cachedPresets = GVAR(containerPresetsHashmap) getOrDefault [_container, nil];

if !(isNil "_cachedPresets") exitWith { _cachedPresets };

if (isNil "_containerPresets") then { _containerPresets = GET_ARRAY(configFile >> "CfgVehicles" >> _container >> QGVAR(availablePresets), []); };
if ((count _containerPresets) == 0) exitWith { [] }; // we're not caching objects that don't have presets at all, don't want a massive hashmap where most of the objects are irrelevant

// validate presets array from config
if (((count _containerPresets) mod 2) != 0) exitWith {WARNING_2("container %1 does not have valid availablePresets array: %2",_container,_containerPresets)};

private _presets = createHashMap;

for "_i" from 0 to ((count _containerPresets) - 1) step 2 do {
    if (((_containerPresets select _i) isEqualType "") && {((_containerPresets select (_i + 1)) isEqualType 0)}) then {
        _presets set [_containerPresets select _i, _containerPresets select (_i + 1)];
    } else {
        WARNING_3("container %1 has invalid preset-budget pair %2 - %3",_container, _containerPresets select _i, _containerPresets select (_i + 1));
    };
};

// cache this for later
GVAR(containerPresetsHashmap) set [_container,_presets];

_presets
