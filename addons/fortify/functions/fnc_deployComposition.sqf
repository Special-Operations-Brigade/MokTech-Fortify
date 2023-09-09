#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Deploys the composition to the player for them to move it around.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Player <OBJECT>
 * 2: Object params (container, classname OR [name, objects, cost, marker]) <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, player, [containerA, "Example_Preset", "Land_BagBunker_Small_F"]] call mti_fortify_fnc_deployComposition
 *
 * Public: No
 */

params ["", "_player", "_params"];
_params params [["_container", objNull, [objNull]], ["_composition", "", ["",[]]]];
TRACE_3("deployComposition",_player,_container, _composition);

MACRO_FNC_MULTIPLYMATRIX;

if (_composition isEqualType "") then {
    private _compositionConfig = [_composition] call FUNC(getCompositionConfig);
    if !(isClass _compositionConfig) exitWith { ERROR_1("composition %1 does not exist in runtime config!"); };

    private _name = GET_TEXT(_compositionConfig >> "displayName", "");
    private _file = GET_TEXT(_compositionConfig >> "file", "");
    private _cost = GET_NUMBER(_compositionConfig >> "cost", 0);
    private _createMarker = GET_NUMBER(_compositionConfig >> "createMarker", 0) > 0;

    private _objects = call (compileScript [_file]);
    if (isNil "_objects" || {!(_objects isEqualType [])}) exitWith {ERROR_2("file %1 does not return valid objects array %2",_file,_objects)};

    private _marker = "";
    if (_createMarker) then {
        private _markerType = GET_TEXT(_compositionConfig >> "markerType", "");
        private _markerColor = GET_TEXT(_compositionConfig >> "markerColor", "");

        _marker = format [
            "|comp_%1|[0,0,0]|%2|ICON|[1,1]|0|Solid|%3|1|%4",
            round CBA_missionTime,_markerType,_markerColor,_name
        ];
    };

    _composition = [_name,_objects,_cost,_marker];
    TRACE_1("composition config data",_composition);
};

_composition params ["_name", "_objects", "_cost", "_marker"];
TRACE_4("composition data",_name,_objects,_cost,_marker);

private _budget = [_container] call FUNC(getCompositionBudget);
if (!(_budget == -1) && (_cost > _budget)) exitWith {["Budget depleted! Deploy cancelled!",2] call ace_common_fnc_displayTextStructured;};

// Create a local only copy of the composition
private _helperObject = "CBA_BuildingPos" createVehicleLocal [0, 0, 0];
_helperObject disableCollisionWith _player;

private _previewObjects = [position _helperObject, getDir _helperObject, _objects, true, false, true] call FUNC(objectsMapper);

GVAR(objectRotationX) = 0;
GVAR(objectRotationY) = 0;
GVAR(objectRotationZ) = 0;

GVAR(isPlacing) = PLACE_WAITING;
GVAR(distanceOffset) = 0;

private _lmb = LLSTRING(confirm);
if (_budget > -1) then {_lmb = _lmb + format [" -%1", [_cost,0] select (_cost < 0)];};
private _rmb = "Cancel";
private _wheel = LLSTRING(rotate);
private _icons = [["+/-", "Change Distance"]];
[_lmb, _rmb, _wheel, _icons] call ace_interaction_fnc_showMouseHint;

private _mouseClickID = [_player, "DefaultAction", {GVAR(isPlacing) == PLACE_WAITING}, {GVAR(isPlacing) = PLACE_APPROVE}] call ace_common_fnc_addActionEventHandler;
[QGVAR(onCompositionDeployStart), [_player, [_helperObject,_objects], _cost]] call CBA_fnc_localEvent;

[{
    params ["_args", "_pfID"];
    _args params ["_unit", "_helperObject", "_cost", "_marker", "_container", "_objects", "_mouseClickID", "_previewObjects", "_fnc_multiplyMatrix"];

    if (_unit != ACE_player || {isNull _helperObject} || {!([_unit, _helperObject, []] call ace_common_fnc_canInteractWith)} || {!([_unit] call FUNC(canFortify))}) then {
        GVAR(isPlacing) = PLACE_CANCEL;
    };

    if (GVAR(isPlacing) != PLACE_WAITING) exitWith {
        TRACE_3("exiting PFEH",GVAR(isPlacing),_pfID,_mouseClickID);
        [_pfID] call CBA_fnc_removePerFrameHandler;
        call ace_interaction_fnc_hideMouseHint;
        [_unit, "DefaultAction", _mouseClickID] call ace_common_fnc_removeActionEventHandler;

        if (GVAR(isPlacing) == PLACE_APPROVE) then {
            TRACE_1("deploying composition",_helperObject);
            GVAR(isPlacing) = PLACE_CANCEL;
            [_unit, _helperObject, _container, _objects, _cost, _marker, _previewObjects] call FUNC(compositionDeployConfirm);
        } else {
            TRACE_1("deleting composition",_helperObject);
            deleteVehicle _helperObject;
            {deleteVehicle _x} forEach _previewObjects;
        };
    };

    ([_helperObject] call FUNC(axisLengths)) params ["_width", "_length", "_height"];
    private _distance = (_width max _length) + 0.5 + GVAR(distanceOffset); // for saftey, move it a bit extra away from player's center
    _distance = [_distance,DISTANCE_MIN,DISTANCE_MAX] call FUNC(clamp);

    private _start = eyePos _unit;
    private _camViewDir = getCameraViewDirection _unit;
    private _basePos = _start vectorAdd (_camViewDir vectorMultiply _distance);
    _basePos set [2, ((_basePos select 2) - (_height / 2)) max (getTerrainHeightASL _basePos - 0.05)];

    _helperObject setPosASL _basePos;

    private _vZ =  180 + GVAR(objectRotationZ) + getDir _unit;
    [_helperObject, 0, 0, _vZ] call ace_common_fnc_setPitchBankYaw;

    //Rotate the relative position using a rotation matrix
	private _rotMatrix = [
		[cos _vZ, sin _vZ],
		[-(sin _vZ), cos _vZ]
	];

    {
	    private _relPos = _x getVariable [QGVAR(objMapper_relPos),[0,0]];
	    private _vectorUp = _x getVariable [QGVAR(objMapper_vectorUp),[0,0,0]];
	    private _azimuth = _x getVariable [QGVAR(objMapper_azimuth),0];

        private _newRelPos = [_rotMatrix,_relPos] call _fnc_multiplyMatrix;
	    private _newPos = [(_basePos select 0) + (_newRelPos select 0), (_basePos select 1) + (_newRelPos select 1), (_relPos select 2)];
        TRACE_CHAT_5("position calculated",_newRelPos,_newPos,_relPos,_basePos,_rotMatrix);

        _x setPosATL _newPos;
        _x setDir (_azimuth + _vZ);

        if ((vectorMagnitude ((surfaceNormal (position _x)) vectorDiff _vectorUp)) > 0.05) then {
            _x setVectorUp _vectorUp;
        } else {
            _x setVectorUp (surfaceNormal _newPos);
        };
    } forEach _previewObjects;

#ifdef DEBUG_MODE_FULL
    //hintSilent format ["Rotation:\nX: %1\nY: %2\nZ: %3", GVAR(objectRotationX), GVAR(objectRotationY), GVAR(objectRotationZ)];
#endif
}, 0, [_player, _helperObject, _cost, _marker, _container, _objects, _mouseClickID, _previewObjects,_fnc_multiplyMatrix]] call CBA_fnc_addPerFrameHandler;
