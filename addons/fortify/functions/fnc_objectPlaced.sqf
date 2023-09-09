#include "script_component.hpp"

/*
Function: mti_fortify_fnc_objectPlaced

Description:
    Handles object being placed, server broadcast

Arguments:
    _unit  - Unit that placed the object
    _container - The container the object was deployed from
    _preset - Class-name of the preset the object was from
    _object - The object that was placed

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_objectPlaced;
    (end)

Author:
	Mokka
*/

params ["_unit", "_container", "_preset", "_object"];
TRACE_4("objectPlaced",_unit,_container,_preset,_object);
private _jipID = [QGVAR(addActionToObject), [_container, _preset, _object]] call CBA_fnc_globalEventJIP;
[_jipID, _object] call CBA_fnc_removeGlobalEventJIP; // idealy this function should be called on the server

if (GVAR(markObjectsOnMap) isNotEqualTo 0 && {_object isKindOf "Static"}) then {
    // Wait ensures correct marker pos/rot as object is moved into position after creation
    [
        FUNC(createObjectMarker),
        [_unit, _object],
        1
    ] call CBA_fnc_waitAndExecute;
};
