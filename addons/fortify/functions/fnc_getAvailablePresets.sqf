#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_getAvailablePresets

Description:
    Returns available presets/containers in area (and from backpack)

Arguments:
    _player - Player to check presets for

Return Value:
    Entries in format [_classname, _container, _totalBudget]

Example:
    (begin example)
        [ACE_player] call mti_fortify_fortify_fnc_getAvailablePresets;
    (end)

Author:
	Mokka
*/

params ["_player"];

if (isNil QGVAR(availablePresetsTimeout)) then {
    GVAR(availablePresetsTimeout) = -1;
};

if (CBA_missionTime < GVAR(availablePresetsTimeout)) exitWith {
    +GVAR(availablePresetsCache)
};

private _availablePresets = [];

// backpack first
private _backpackPresets = [backpack _player] call FUNC(getContainerPresets);

// in backpack case, _player itself is the container
{
    _availablePresets pushBack [_x, _player, _y];
} forEach _backpackPresets;

// nearby containers
{
    if (_x isKindOf "CAManBase") then {continue;};
    private _object = _x;
    {
        _availablePresets pushBack [_x, _object, _y];
    } forEach ([_object] call FUNC(getContainerPresets));
} forEach ((position _player) nearObjects ["All",CONTAINER_SEARCH_RADIUS]);

GVAR(availablePresetsCache) = _availablePresets;
GVAR(availablePresetsTimeout) = CBA_missionTime + CONTAINER_SEARCH_TIMEOUT;

TRACE_2("cached value",GVAR(availablePresetsCache),GVAR(availablePresetsTimeout));

+GVAR(availablePresetsCache)
