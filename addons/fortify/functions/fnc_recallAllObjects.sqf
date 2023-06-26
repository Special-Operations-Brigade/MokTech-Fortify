#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_recallAllObjects

Description:
    Recalls all preset objects deployed from given container, returning budget.

Arguments:
    action args

Return Value:
    None

Example:
    (begin example)
        [...] call mti_fortify_fortify_fnc_recallAllObjects;
    (end)

Author:
	Mokka
*/

/*
    todo: figure out if we want to limit the range of the recall?! e.g. only objects within 100m can be recalled using this....
*/

params ["_target", "_player", "_args"];
_args params ["_container", "_preset", "_displayName"];

private _deployedObjects = _container getVariable (format[QGVAR(deployedObjects_%1),_preset]);
private _totalTime = GVAR(recallTimeCoef) * (count _deployedObjects);

private _fnc_recallFinished = {
    (_this select 0) params ["_target","_player","_container","_preset","_displayName","_deployedObjects"];
    {
        private _className = _x;
        private _objects = +(_y select 1);

        {
            TRACE_4("deleting placed object",_x,_className,_container,_preset);

            [QGVAR(objectDeleted), [_player, _container, _preset, _x]] call CBA_fnc_globalEvent;

            private _typeOf = typeOf _x;
            private _cost = [_preset, _typeOf] call FUNC(getCost);

            [_container, _preset, _cost] call FUNC(updateBudget);
            [_container, _preset, _x, -1] call FUNC(updateObjectCount);

            deleteVehicle _x;
        } forEach _objects;
    } forEach _deployedObjects;

    _container setVariable [(format[QGVAR(deployedObjects_%1),_preset]),nil,true];
};

[
    _totalTime,
    [_target,_player,_container,_preset,_displayName,_deployedObjects],
    _fnc_recallFinished,
    {},
    "Recalling Objects..."
] call ace_common_fnc_progressBar;
