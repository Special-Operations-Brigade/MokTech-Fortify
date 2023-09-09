#include "script_component.hpp"

/*
Function: mti_fortify_fnc_getPresetConfig

Description:
    Helper function to get config path to given preset.

Arguments:
    _preset - Preset

Return Value:
    Config Path

Example:
    (begin example)
        ["Example_Preset"] call mti_fortify_fnc_getPresetConfig;
    (end)

Author:
	Mokka
*/

params ["_preset"];

private _config = missionconfigFile >> QGVAR(Presets) >> _preset;

if !(isClass _config) then { _config = configFile >> QGVAR(Presets) >> _preset; };
//if !(isClass _config) then { WARNING_1("preset %1 not found in runtime config"); };

_config
