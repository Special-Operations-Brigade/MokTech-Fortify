#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Gets the budget for the given container.
 *
 * Arguments:
 * 0: Container <OBJECT>
 * 1: Preset <STRING>
 *
 * Return Value:
 * Budget <NUMBER>
 *
 * Example:
 * [cursorTarget, "Example_Preset"] call mti_fortify_fortify_fnc_getBudget
 *
 * Public: Yes
 */

params ["_container", "_preset"];

private _presets = [_container] call FUNC(getContainerPresets);

if ((count _presets) == 0) exitWith {0};

private _initialBudget = _presets getOrDefault [_preset, -2];

if (_initialBudget == -2) exitWith {WARNING_2("preset %1 is not defined for container %2",_preset,typeOf _container); 0};

private _currentBudget = _container getVariable [format[QGVAR(budget_%1),_preset], _initialBudget];

_currentBudget;
