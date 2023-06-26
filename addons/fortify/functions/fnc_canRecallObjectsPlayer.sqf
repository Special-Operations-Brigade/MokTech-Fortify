#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_canRecallObjectsPlayer

Description:
    Checks whether player has any objects to recall to the backpack.

Arguments:
    _player - Player

Return Value:
    canRecallObjects?

Example:
    (begin example)
        [ace_player] call mti_fortify_fortify_fnc_canRecallObjectsPlayer;
    (end)

Author:
	Mokka
*/

params ["_player"];

private _presets = [_player] call FUNC(getContainerPresets);

private _totalCount = 0;

{
    private _deployedObjects = _player getVariable [(format[QGVAR(deployedObjects_%1),_x]),[]];
    { _totalCount = _totalCount + (_y select 0); } forEach _deployedObjects;
} forEach _presets;

(_totalCount > 0)
