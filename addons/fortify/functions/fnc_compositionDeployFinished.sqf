#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_compositionDeployFinished

Description:
    Handles placing the composition after placement, runs post-deploy handlers and triggers events.

Arguments:
    ...

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fortify_fnc_compositionDeployFinished;
    (end)

Author:
	Mokka
*/

params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
_args params ["_unit", "_container", "_objects", "_posASL", "_azimuth", "_cost", "_marker"];

private _newObjects = [_posASL,_azimuth,_objects,false,false,true] call FUNC(objectsMapper);

[
    {
        params ["_unit", "_container", "_objects", "_posASL", "_azimuth", "_cost", "_marker", "_newObjects"];

        MACRO_FNC_MULTIPLYMATRIX;

        private _rotMatrix = [
            [cos _azimuth, sin _azimuth],
            [-(sin _azimuth), cos _azimuth]
        ];

        {
            private _relPos = _x getVariable [QGVAR(objMapper_relPos),[0,0]];
            private _vectorUp = _x getVariable [QGVAR(objMapper_vectorUp),[0,0,0]];
            private _objAzimuth = _x getVariable [QGVAR(objMapper_azimuth),0];

            private _newRelPos = [_rotMatrix,_relPos] call _fnc_multiplyMatrix;
            private _newPos = [(_posASL select 0) + (_newRelPos select 0), (_posASL select 1) + (_newRelPos select 1), (_relPos select 2)];
            TRACE_5("final position calculated",_newRelPos,_newPos,_relPos,_posASL,_rotMatrix);

            _x setPosATL _newPos;
            _x setDir (_azimuth + _objAzimuth);

            if ((vectorMagnitude ((surfaceNormal (position _x)) vectorDiff _vectorUp)) > 0.05) then {
                _x setVectorUp _vectorUp;
            } else {
                _x setVectorUp (surfaceNormal _newPos);
            };

            _x setVariable [QGVAR(object_cost),(_cost / (count _newObjects)), true]; // set individual object cost to the comp's average
        } forEach _newObjects;

        // Server will use this event to run the jip compatible QGVAR(addActionToObject) event and create the related map marker
        [QGVAR(compositionPlaced), [_unit, _container, _newObjects, _marker, _posASL, _cost]] call CBA_fnc_globalEvent;
    }, [_unit, _container, _objects, _posASL, _azimuth, _cost, _marker, _newObjects]
] call CBA_fnc_execNextFrame;

// Reset animation
[_unit, "", 2] call ace_common_fnc_doAnimation;
