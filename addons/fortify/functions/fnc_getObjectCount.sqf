#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_getObjectCount

Description:
    Returns how often given object has already been deployed from a container.

Arguments:
    _container
    _preset
    _typeOf

Return Value:
    None

Example:
    (begin example)
        [cursorTarget, "Example_Preset", "Sandbag"] call mti_fortify_fortify_fnc_getObjectCount;
    (end)

Author:
	Mokka
*/

params ["_container", "_preset", "_typeOf"];

private _deployedObjects = _container getVariable (format[QGVAR(deployedObjects_%1),_preset]);
//TRACE_1("deployed objects",_deployedObjects);
if (isNil "_deployedObjects") exitWith {0};

((_deployedObjects getOrDefault [_typeOf,[0,[]]]) select 0)
