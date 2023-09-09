#include "script_component.hpp"

/*
Function: mti_fortify_fnc_postDeploy_medicalFacility

Description:
    Handles setting up certain objects as medical facilities post-deploy with Fortify.

Arguments:
    _unit - Unit <OBJECT>
    _object - Object being placed <OBJECT>
    _cost - Cost <NUMBER>
    _container - Container <OBJECT>
    _preset - Preset <STRING>

Return Value:
    None

Example:
    (begin example)
        [...] call mti_fortify_fnc_postDeploy_medicalFacility;
    (end)

Author:
	Mokka
*/

params ["_unit","_object","_cost","_container","_preset"];

private _found = false;

{
    if ((typeOf _object) == _x) exitWith {_found = true;};
} forEach GVAR(medicalFacilities);

if !(_found) exitWith {};

_object setVariable ["ace_medical_isMedicalFacility",true,true];
