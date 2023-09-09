#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Checks whether the given player can fortify.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: check area? <BOOL> (optional, default: true)
 *
 * Return Value:
 * Can Fortify <BOOL>
 *
 * Example:
 * [player] call mti_fortify_fnc_canFortify
 *
 * Public: Yes
 */

params ["_player", ["_checkArea",true,[true]]];

private _canFortifyCfg = GET_NUMBER(configFile >> "CfgVehicles" >> (backpack _player) >> QGVAR(canFortify),0) > 0;
private _canFortifyVar = _player getVariable [QGVAR(canFortify),false];

(_canFortifyCfg || _canFortifyVar) &&
{missionNamespace getVariable [QGVAR(fortifyAllowed), true]} &&
{(count ([_player] call FUNC(getAvailablePresets))) > 0} &&
{
    (not _checkArea) || {
        private _inArea = GVAR(locations) isEqualTo [];
        { if (_player inArea _x) exitWith {_inArea = true}; } forEach GVAR(locations);
        _inArea
    }
}
