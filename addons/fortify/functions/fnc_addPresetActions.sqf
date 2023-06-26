#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_addPresetActions

Description:
    Adds child actions to the presets for each object.

Arguments:
    Parent action arguments

Return Value:
    Preset child actions

Example:
    (begin example)
        [...] call mti_fortify_fortify_fnc_addPresetActions;
    (end)

Author:
	Mokka
*/

params ["_target", "_player", "_args"];
_args params ["_preset", "_container"];

private _actions = [];
private _objects = [_preset] call FUNC(getPresetObjects);

{
    _x params ["_objectClass","_objectCost","_objectLimit"];

    private _displayName = getText (configFile >> "CfgVehicles" >> _objectClass >> "displayName");
    private _budget = [_container, _preset] call FUNC(getBudget);
    private _count = [_container, _preset, _objectClass] call FUNC(getObjectCount);

    if (_objectCost > 0) then {_displayName = format ["%1 - %2", _objectCost, _displayName]};
    if (_objectLimit != -1) then {
        _displayName = format ["%1 (%2/%3)",_displayName,_count,_objectLimit];
    };

    if !(((_budget == -1) || {_budget >= _objectCost}) && {(_objectLimit == -1) || {_objectLimit > _count}}) then {
        _displayName = format ["<t color='#ff0000'>%1</t>",_displayName];
    };

    private _action = [
        _objectClass,
        _displayName,
        "",
        {_this call FUNC(deployObject)},
        {true},
        {},
        [_container, _preset, _objectClass, _objectCost, _objectLimit]
    ] call ace_interact_menu_fnc_createAction;

    _actions pushBack [_action, [], _player];
} forEach _objects;

_actions
