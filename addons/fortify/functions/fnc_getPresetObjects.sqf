#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_getPresetObjects

Description:
    Returns all of a preset's objects, costs and limits

Arguments:
    _preset - The preset

Return Value:
    All preset's objects, budgets and limits

Example:
    (begin example)
        ["Example_Preset"] call mti_fortify_fortify_fnc_getPresetObjects;
    (end)

Author:
	Mokka
*/

params ["_preset"];

private _return = [];
private _config = [_preset] call FUNC(getPresetConfig);

private _objects = "true" configClasses (_config >> "Objects");

{
    private _className = GET_TEXT(_x >> "name", "");
    private _cost = GET_NUMBER(_x >> "cost", 0);
    private _limit = GET_NUMBER(_x >> "limit", -1);

    _return pushBack [_className, _cost, _limit];
} forEach _objects;

_return
