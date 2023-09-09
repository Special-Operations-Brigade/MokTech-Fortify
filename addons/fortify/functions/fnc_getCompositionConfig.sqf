#include "script_component.hpp"

/*
Function: mti_fortify_fnc_getCompositionConfig

Description:
    Helper function to get config path to given composition.

Arguments:
    _composition - Composition

Return Value:
    Config Path

Example:
    (begin example)
        ["Example_Composition"] call mti_fortify_fnc_getCompositionConfig;
    (end)

Author:
	Mokka
*/

params ["_composition"];

private _config = missionconfigFile >> QGVAR(Compositions) >> _composition;

if !(isClass _config) then { _config = configFile >> QGVAR(Compositions) >> _composition; };
//if !(isClass _config) then { WARNING_1("composition %1 not found in runtime config"); };

_config
