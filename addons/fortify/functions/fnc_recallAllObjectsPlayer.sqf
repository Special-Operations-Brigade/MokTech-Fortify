#include "script_component.hpp"

/*
Function: mti_fortify_fnc_recallAllObjectsPlayer

Description:
    Recalls all objects placed from player backpack

Arguments:
    _player - Player

Return Value:
    None

Example:
    (begin example)
        [ace_player] call mti_fortify_fnc_recallAllObjectsPlayer;
    (end)

Author:
	Mokka
*/

/*
    todo: figure out if we want to limit the range of the recall?! e.g. only objects within 100m can be recalled using this....
*/

params ["_player"];

private _presets = [_player] call FUNC(getContainerPresets);
private _totalTime = 0;

{
    private _preset = _x;
    private _deployedObjects = _player getVariable (format[QGVAR(deployedObjects_%1),_preset]);

    _totalTime = _totalTime + (GVAR(recallTimeCoef) + (count _deployedObjects));
} forEach _presets;

private _fnc_recallFinished = {
    (_this select 0) params ["_player", "_presets"];
    {
        private _preset = _x;
        private _deployedObjects = _player getVariable (format[QGVAR(deployedObjects_%1),_preset]);

        {
            private _className = _x;
            private _objects = +(_y select 1);

            {
                TRACE_4("deleting placed object",_x,_className,_player,_preset);

                [QGVAR(objectDeleted), [_player, _player, _preset, _x]] call CBA_fnc_globalEvent;

                private _typeOf = typeOf _x;
                private _cost = [_preset, _typeOf] call FUNC(getCost);

                [_player, _preset, _cost] call FUNC(updateBudget);
                [_player, _preset, _x, -1] call FUNC(updateObjectCount);

                deleteVehicle _x;
            } forEach _objects;
        } forEach _deployedObjects;

        _player setVariable [(format[QGVAR(deployedObjects_%1),_preset]),nil,true];
    } forEach _presets;
};

[
    _totalTime,
    [_player,_presets],
    _fnc_recallFinished,
    {},
    "Recalling Objects..."
] call ace_common_fnc_progressBar;
