#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_updateObjectCount

Description:
    Updates deployedObjects variable on the container.

Arguments:
    _container
    _preset
    _object
    _change

Return Value:
    None

Example:
    (begin example)
        [containerA, "Example_Preset", "Sandbag", +1] call mti_fortify_fortify_fnc_updateObjectCount;
    (end)

Author:
	Mokka
*/

params ["_container", "_preset", "_object", "_change"];
TRACE_4("update object count",_container,_preset,_object,_change);

if (_change == 0) exitWith { WARNING_1("_change is 0! _this: %1",_this); };

private _typeOf = typeOf _object;

private _deployedObjects = _container getVariable (format[QGVAR(deployedObjects_%1),_preset]);
TRACE_1("deployed objects",_deployedObjects);
if (isNil "_deployedObjects") then { _deployedObjects = createHashMap; };

private _deployed = _deployedObjects getOrDefault [_typeOf,[0,[]]];

private _count = (_deployed select 0) + _change;

private _objects = [];
if (_change > 0) then {
    _objects = (_deployed select 1) + [_object];
} else {
    _objects = (_deployed select 1) - [_object];
};

_deployedObjects set [_typeOf,[_count,_objects]];

_container setVariable [format[QGVAR(deployedObjects_%1),_preset], _deployedObjects, true];
