#include "script_component.hpp"

/*
Function: mti_fortify_fnc_addActionToObject

Description:
    Adds action to remove and edit object after it was deployed.

Arguments:
    _container - Container the objects was deployed from
    _preset - Preset the object was deployed from
    _object - The object itself

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_addActionToObject;
    (end)

Author:
	Mokka
*/

params ["_container", "_preset", "_object"];
TRACE_3("addActionToObject EH",_container,_preset,_object);

if (isNull _object) exitWith {};
// if deployed from backpack: only add remove/edit action on local player who deployed it
if (_container isKindOf "CAManBase" && {!(_container isEqualTo ACE_player)}) exitWith {};

private _budget = [_container,_preset] call FUNC(getBudget);
private _cost = [_preset, typeOf _object] call FUNC(getCost);
private _text = [format ["Remove Object +%1", _cost], "Remove Object"] select (_budget == -1);

// Remove object action
private _removeAction = [
    QGVAR(removeObject),
    _text,
    "",
    {
        params ["_target", "_player", "_params"];
        _params params ["_container", "_preset", "_cost"];
        TRACE_2("deleting placed object",_target,_params);

        [QGVAR(objectDeleted), [_player, _container, _preset, _target]] call CBA_fnc_globalEvent;

        [_container, _preset, _cost] call FUNC(updateBudget);
        [_container, _preset, _target, -1] call FUNC(updateObjectCount);

        deleteVehicle _target;
    },
    {[_player,false] call FUNC(canFortify)},
    {},
    [_container, _preset, _cost],
    {[0, 0, 0]},
    5
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _removeAction] call ace_interact_menu_fnc_addActionToObject;
