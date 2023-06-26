#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Updates the given container's budget.
 *
 * Arguments:
 * 0: Container <OBJECT>
 * 1: Preset <STRING>
 * 2: Change <NUMBER> (default: 0)
 *
 * Return Value:
 * None
 *
 * Example:
 * [containerA, "Example_Preset", -250] call mti_fortify_fortify_fnc_updateBudget
 *
 * Public: Yes
 */

params [["_container", objNull, [objNull]], ["_preset", "", [""]], ["_change", 0, [0]]];
TRACE_3("updateBudget",_container,_preset,_change);

if !(alive _container) exitWith {ERROR("_container is null or dead");};
if (_preset == "") exitWith {ERROR("_preset must not be empty");};

private _budget = [_container,_preset] call FUNC(getBudget);
private _newBudget = _budget + _change;

_newBudget = 0 max _newBudget;

if (_budget != -1) then {
    _container setVariable [format [QGVAR(Budget_%1), _preset], _newBudget, true];
};
