#include "script_component.hpp"

/*
Function: mti_fortify_fnc_deployFinished

Description:
    Deploys the object after placement, runs post-deploy handlers and triggers events

Arguments:
    ...

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_deployFinished;
    (end)

Author:
	Mokka
*/

params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
_args params ["_unit", "_container", "_preset", "_typeOf", "_posASL", "_vectorDir", "_vectorUp", "_cost"];

private _newObject = createVehicle [_typeOf, _posASL, [], 0, "CAN_COLLIDE"];

_posASL = _unit getVariable [QGVAR(posASL),[0,0]];
_vectorUp = _unit getVariable [QGVAR(vectorUp),[0,0,0]];
_vectorDir = _unit getVariable [QGVAR(vectorDir),[0,0,0]];

[{
    params ["_newObject","_posASL","_vectorDir","_vectorUp"];
    _newObject setPosASL _posASL;
    _newObject setVectorDirAndUp [_vectorDir, _vectorUp];
},[_newObject,_posASL,_vectorDir,_vectorUp]] call CBA_fnc_execNextFrame;

_newObject setVariable [QGVAR(object_cost),_cost, true];

{
    [_unit, _newObject, _cost, _container, _preset] call _x;
} forEach GVAR(postDeployHandlers);

// Server will use this event to run the jip compatible QGVAR(addActionToObject) event and create the related map marker
[QGVAR(objectPlaced), [_unit, _container, _preset, _newObject]] call CBA_fnc_globalEvent;

// update object count
[_container, _preset, _newObject, +1] call FUNC(updateObjectCount);

if (cba_events_control) then {
    // Re-run if ctrl key held
    [_unit, _unit, [_container, _preset, _typeOf, [GVAR(objectRotationX), GVAR(objectRotationY), GVAR(objectRotationZ)]]] call FUNC(deployObject);
};

// Reset animation
[_unit, "", 2] call ace_common_fnc_doAnimation;
