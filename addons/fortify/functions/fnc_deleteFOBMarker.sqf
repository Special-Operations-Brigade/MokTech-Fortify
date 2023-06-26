#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_deleteFOBMarker

Description:
    Delete the FOB marker of the given target.

Arguments:
    _player
    _target

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fortify_fnc_deleteFOBMarker;
    (end)

Author:
	Mokka
*/

params ["_player","_target"];

private _marker = _target getVariable QGVAR(FOBMarker);

if !(isNil "_marker") then {
	deleteMarker _marker;
	_target setVariable [QGVAR(FOBMarker),nil,true];
};

["Marker Deleted"] call ACE_common_fnc_displayTextStructured;
