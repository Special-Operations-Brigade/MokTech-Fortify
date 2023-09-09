#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Deploys the object to the player for them to move it around.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Player <OBJECT>
 * 2: Object params (container, preset, classname, rotations) <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, player, [containerA, "Example_Preset", "Land_BagBunker_Small_F"]] call mti_fortify_fnc_deployObject
 *
 * Public: No
 */

params ["", "_player", "_params"];
_params params [["_container", objNull, [objNull]], ["_preset", "", [""]], ["_classname", "", [""]], ["_cost", 0, [0]], ["_limit", -1, [0]], ["_rotations", [0,0,0]]];
TRACE_7("deployObject",_player,_container, _preset,_classname,_cost,_limit,_rotations);

private _budget = [_container,_preset] call FUNC(getBudget);

private _count = [_container, _preset, _classname] call FUNC(getObjectCount);
if (!(_limit == -1) && (_count >= _limit)) exitWith {["Object limit exceeded! Deploy cancelled!",2] call ace_common_fnc_displayTextStructured;};

private _budget = [_container, _preset] call FUNC(getBudget);
if (!(_budget == -1) && (_cost > _budget)) exitWith {["Budget depleted! Deploy cancelled!",2] call ace_common_fnc_displayTextStructured;};

// Create a local only copy of the object
private _object = _classname createVehicleLocal [0, 0, 0];
_object disableCollisionWith _player;

GVAR(objectRotationX) = _rotations select 0;
GVAR(objectRotationY) = _rotations select 1;
GVAR(objectRotationZ) = _rotations select 2;

GVAR(isPlacing) = PLACE_WAITING;
GVAR(distanceOffset) = 0;

private _lmb = LLSTRING(confirm);
if (_budget > -1) then {_lmb = _lmb + format [" -%1", [_cost,0] select (_cost < 0)];};
private _rmb = "Cancel";
private _wheel = LLSTRING(rotate);
private _xAxis = localize "str_disp_conf_xaxis";
private _icons = [["alt", localize "str_3den_display3den_entitymenu_movesurface_text"], ["shift", localize "str_disp_conf_xaxis" + " " + _wheel], ["control", localize "str_disp_conf_yaxis" + " " + _wheel], ["+/-", "Change Distance"]];
[_lmb, _rmb, _wheel, _icons] call ace_interaction_fnc_showMouseHint;

private _mouseClickID = [_player, "DefaultAction", {GVAR(isPlacing) == PLACE_WAITING}, {GVAR(isPlacing) = PLACE_APPROVE}] call ace_common_fnc_addActionEventHandler;
[QGVAR(onDeployStart), [_player, _object, _cost]] call CBA_fnc_localEvent;

[{
    params ["_args", "_pfID"];
    _args params ["_unit", "_object", "_cost", "_container", "_preset", "_mouseClickID"];

    if (_unit != ACE_player || {isNull _object} || {!([_unit, _object, []] call ace_common_fnc_canInteractWith)} || {!([_unit] call FUNC(canFortify))}) then {
        GVAR(isPlacing) = PLACE_CANCEL;
    };

    // If place approved, verify deploy handlers
    if (GVAR(isPlacing) == PLACE_APPROVE && {(GVAR(deployHandlers) findIf {([_unit, _object, _cost, _container, _preset] call _x) isEqualTo false}) > -1}) then {
        GVAR(isPlacing) = PLACE_WAITING;
    };

    if (GVAR(isPlacing) != PLACE_WAITING) exitWith {
        TRACE_3("exiting PFEH",GVAR(isPlacing),_pfID,_mouseClickID);
        [_pfID] call CBA_fnc_removePerFrameHandler;
        call ace_interaction_fnc_hideMouseHint;
        [_unit, "DefaultAction", _mouseClickID] call ace_common_fnc_removeActionEventHandler;

        if (GVAR(isPlacing) == PLACE_APPROVE) then {
            TRACE_1("deploying object",_object);
            GVAR(isPlacing) = PLACE_CANCEL;
            [_unit, _object, _container, _preset] call FUNC(deployConfirm);
        } else {
            TRACE_1("deleting object",_object);
            deleteVehicle _object;
        };
    };

    // todo: add keybind to move object up/down along z axis
    ([_object] call FUNC(axisLengths)) params ["_width", "_length", "_height"];
    private _distance = (_width max _length) + 0.5 + GVAR(distanceOffset); // for safety, move it a bit extra away from player's center
    _distance = [_distance,DISTANCE_MIN,DISTANCE_MAX] call FUNC(clamp);

    private _start = eyePos _unit;
    private _camViewDir = getCameraViewDirection _unit;
    private _basePos = _start vectorAdd (_camViewDir vectorMultiply _distance);
    _basePos set [2, ((_basePos select 2) - (_height / 2)) max (getTerrainHeightASL _basePos - 0.05)];

    _object setPosASL _basePos;

    private _vZ =  180 + GVAR(objectRotationZ) + getDir _unit;
    if (cba_events_alt) then {
        // Snap to terrain surface dir
        _object setDir _vZ;
        _object setVectorUp (surfaceNormal _basePos);
    } else {
        [_object, GVAR(objectRotationX), GVAR(objectRotationY), _vZ] call ace_common_fnc_setPitchBankYaw;
    };

    _unit setVariable [QGVAR(posASL),_basePos,false];
    _unit setVariable [QGVAR(vectorUp),vectorUp _object,false];
    _unit setVariable [QGVAR(vectorDir),vectorDir _object,false];

    #ifdef DEBUG_MODE_FULL
    //hintSilent format ["Rotation:\nX: %1\nY: %2\nZ: %3", GVAR(objectRotationX), GVAR(objectRotationY), GVAR(objectRotationZ)];
    #endif
}, 0, [_player, _object, _cost, _container, _preset, _mouseClickID]] call CBA_fnc_addPerFrameHandler;
