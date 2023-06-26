#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_recallAllCompositions

Description:
    Recalls all objects deployed from given container through compositions.

Arguments:
    action args

Return Value:
    None

Example:
    (begin example)
        [...] call mti_fortify_fortify_fnc_recallAllCompositions;
    (end)

Author:
	Mokka
*/

/*
    todo: figure out if we want to limit the range of the recall?! e.g. only objects within 100m can be recalled using this....
*/

params ["_target", "_player", "_args"];

private _deployedObjects = _target getVariable [QGVAR(deployedCompositionObjects),[]];
private _totalTime = GVAR(recallTimeCoef) * (count _deployedObjects);

private _fnc_recallFinished = {
    (_this select 0) params ["_target","_player","_deployedObjects"];
    {
        _x params ["_objects","_cost","_marker"];

        [_target, _cost] call FUNC(updateCompositionBudget);
        deleteMarker _marker;

        {
            TRACE_2("deleting placed object",_x,_container);
            deleteVehicle _x;
        } forEach _objects;
    } forEach _deployedObjects;

    _target setVariable [QGVAR(deployedCompositionObjects),nil,true];
};

[
    _totalTime,
    [_target,_player,_deployedObjects],
    _fnc_recallFinished,
    {},
    "Recalling Objects..."
] call ace_common_fnc_progressBar;
