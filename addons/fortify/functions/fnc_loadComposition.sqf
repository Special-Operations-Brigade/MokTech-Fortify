#include "script_component.hpp"

/*
Function: mti_fortify_fnc_loadComposition

Description:
    Handles loading a composition from a save container.

Arguments:
    ACE Action Arguments

Return Value:
    None

Example:
    (begin example)
        [...] call mti_fortify_fnc_loadComposition;
    (end)

Author:
	Mokka
*/

params ["_target", "_player"];

// Requires ZEN
if !(isClass (configFile >> "CfgPatches" >> "zen_dialog")) exitWith {
	["Requires Zeus Enhanced to work!"] call ACE_common_fnc_displayTextStructured;
};

private _config = configOf _target;

private _radius =_target getVariable QGVAR(saveRange);
if (isNil "_radius") then { _radius = GET_NUMBER(_config >> QGVAR(saveRange),CONST_DEFAULT_SAVE_RADIUS) };

private _maxBudget = _target getVariable QGVAR(saveMaxBudget);
if (isNil "_maxBudget") then { _maxBudget = GET_NUMBER(_config >> QGVAR(saveMaxBudget),CONST_DEFAULT_SAVE_MAXBUDGET) };

private _savedCompositions = profileNamespace getVariable [QGVAR(saved_compositions),createHashMap];

private _savedNames = [];
private _savedData = [];

{
    if ((count _y) != 2) then { WARNING_2("invalid data in saved compositions: %3 (idx: %2 | %1)",_x,_forEachIndex,_y); continue; };

    private _name = _x;
    private _data = _y;
    _data params ["_objects","_cost"];

    _name = format ["%1 (%2)",_name,_cost];

    _savedNames pushBack _name;
    _savedData pushBack [_name,_objects,_cost];

    TRACE_3("checking saved compositions",_x,_name,_forEachIndex);
} forEach _savedCompositions;

if (count _savedCompositions == 0) then {
    _savedNames = ["- No Saved Compositions Found! -"];
    _savedData = [""];
};

[
    format ["[SOB] Load Composition (Budget: %1)",_maxBudget], [
        [
            "LIST",
            ["Composition", "Which composition to load. Make sure selected composition's cost does not exceed budget."],
            [
                _savedData,
                _savedNames,
                0
            ],
            false
        ], [
            "CHECKBOX",
            ["Create Marker","When checked, a marker will be created on the position of the loaded composition."],
            false,
            true
        ]
    ], {
        // on confirm
        params ["_values", "_args"];
        _values params ["_data", "_createMarker"];
        _data params ["_name","_objects","_cost"];
        _args params ["_container","_player","_maxBudget"];

        if (_data isEqualTo "") exitWith {};
        if (_cost > _maxBudget) exitWith {["Budget exceeded! Deploy cancelled!",2] call ace_common_fnc_displayTextStructured;};

        private _marker = "";
        if (_createMarker) then {
            _marker = format[
                "|comp_%1|[0,0,0]|hd_flag|ICON|[1,1]|0|Solid|ColorBlack|1|%2",
                round CBA_missionTime,_name
            ];
        };

        _container setVariable [QGVAR(used),true,true];
        [_container,_player,[_container,[_name,_objects,-1,_marker]]] call FUNC(deployComposition);
    }, {
        // on cancel
    }, [_target,_player,_maxBudget], QGVAR(loadDialog)
] call zen_dialog_fnc_create;


nil
