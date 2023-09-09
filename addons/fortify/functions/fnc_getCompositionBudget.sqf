#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Gets the budget for the given container.
 *
 * Arguments:
 * 0: Container <OBJECT>
 *
 * Return Value:
 * Budget <NUMBER>
 *
 * Example:
 * [cursorTarget] call mti_fortify_fnc_getCompositionBudget
 *
 * Public: Yes
 */

params ["_container"];

private _initialBudget = _container getVariable [QGVAR(compositionBudget),-2];
if (_initialBudget == -2) then { _initialBudget = GET_NUMBER(configFile >> "CfgVehicles" >> (typeOf _container) >> QGVAR(compositionBudget),-2); };
if (_initialBudget == -2) exitWith {WARNING_2("composition budget is not defined for container %1",typeOf _container); 0};

private _currentBudget = _container getVariable [QGVAR(composition_budget), _initialBudget];

_currentBudget;
