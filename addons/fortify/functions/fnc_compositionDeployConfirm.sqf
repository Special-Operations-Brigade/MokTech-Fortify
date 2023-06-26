#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Confirms the deployment.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Helper object <OBJECT>
 * 2: Container <OBJECT>
 * 3: Composition Object <OBJECT>
 * 4: Cost <NUMBER>
 * 5: Marker in string format <STRING>
 * 6: Preview objects <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, wall] call mti_fortify_fortify_fnc_compositionDeployConfirm
 *
 * Public: No
 */

params ["_unit", "_helperObject", "_container", "_objects", "_cost", "_marker", "_previewObjects"];
TRACE_6("compositionDeployConfirm",_unit, _helperObject, _container, _objects, _cost, _marker, _previewObjects);

[_container, -_cost] call FUNC(updateCompositionBudget);

private _posASL = getPosASL _helperObject;
private _azimuth = getDir _helperObject;

deleteVehicle _helperObject;
{ deleteVehicle _x; } forEach _previewObjects;

// Create progress bar to place object
private _totalTime = (_cost * GVAR(timeCostCoefficient) + GVAR(timeMin)) min GVAR(timeMax); // time = (Ax + b) min c

private _perframeCheck = {
    params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
    _args params ["_unit", "_container", "_objects", "_posASL", "_azimuth", "_cost", "_marker"];

    // Animation loop (required for longer constructions)
    if (animationState _unit isNotEqualTo "AinvPknlMstpSnonWnonDnon_medic4") then {
        // Perform animation
        [_unit, "AinvPknlMstpSnonWnonDnon_medic4"] call ace_common_fnc_doAnimation;
    };

    // Return true always
    true
};

[
    _totalTime,
    [_unit, _container, _objects, _posASL, _azimuth, _cost, _marker],
    QGVAR(compositionDeployFinished),
    QGVAR(compositionDeployCanceled),
    LLSTRING(progressBarTitle),
    _perframeCheck
] call ace_common_fnc_progressBar;

