#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Updates the given container's budget.
 *
 * Arguments:
 * 0: Container <OBJECT>
 * 1: Change <NUMBER> (default: 0)
 *
 * Return Value:
 * None
 *
 * Example:
 * [containerA, -250] call mti_fortify_fnc_updateCompositionBudget
 *
 * Public: Yes
 */

params [["_container", objNull, [objNull]], ["_change", 0, [0]]];
TRACE_2("updateCompositionBudget",_container,_change);

if !(alive _container) exitWith {ERROR("_container is null or dead");};

private _budget = [_container] call FUNC(getCompositionBudget);
private _newBudget = _budget + _change;

_newBudget = 0 max _newBudget;

if (_budget != -1) then {
    _container setVariable [QGVAR(composition_budget), _newBudget, true];
};
