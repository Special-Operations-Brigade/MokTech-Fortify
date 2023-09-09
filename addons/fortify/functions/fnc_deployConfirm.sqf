#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Confirms the deployment.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Fortify Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, wall] call mti_fortify_fnc_deployConfirm
 *
 * Public: No
 */

params ["_unit", "_object", "_container", "_preset"];
TRACE_4("deployConfirm",_unit,_object,_container,_preset);

private _typeOf = typeOf _object;
private _cost = [_preset, _typeOf] call FUNC(getCost);
[_container, _preset, -_cost] call FUNC(updateBudget);

private _posASL = getPosASL _object;
private _vectorUp = vectorUp _object;
private _vectorDir = vectorDir _object;

deleteVehicle _object;

// Create progress bar to place object
private _totalTime = (_cost * GVAR(timeCostCoefficient) + GVAR(timeMin)) min GVAR(timeMax); // time = (Ax + b) min c

private _perframeCheck = {
    params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
    _args params ["_unit", "_container", "_preset", "_typeOf", "_posASL", "_vectorDir", "_vectorUp", "_cost"];

    // Animation loop (required for longer constructions)
    if (animationState _unit isNotEqualTo "AinvPknlMstpSnonWnonDnon_medic4") then {
        // Perform animation
        [_unit, "AinvPknlMstpSnonWnonDnon_medic4"] call ace_common_fnc_doAnimation;
    };

    // Return true always
    true
};

[_container, _preset, _typeOf] call FUNC(addContainerActions);

[
    _totalTime,
    [_unit, _container, _preset, _typeOf, _posASL, _vectorDir, _vectorUp, _cost],
    QGVAR(deployFinished),
    QGVAR(deployCanceled),
    LLSTRING(progressBarTitle),
    _perframeCheck
] call ace_common_fnc_progressBar;

