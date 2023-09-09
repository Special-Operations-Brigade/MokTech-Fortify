#include "script_component.hpp"

/*
Function: mti_fortify_fnc_canCreateFOBMarker

Description:
    Checks whether an FOB marker can be deployed from given object.

Arguments:
    _player
    _target

Return Value:
    canCreateFOBMarker?

Example:
    (begin example)
        [] call mti_fortify_fnc_canCreateFOBMarker;
    (end)

Author:
	Mokka
*/

params ["_player","_target"];

private _marker = _target getVariable QGVAR(FOBMarker);

((isNil "_marker") && (GVAR(markObjectsOnMap) > 0))
