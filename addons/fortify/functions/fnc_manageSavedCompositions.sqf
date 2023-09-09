#include "script_component.hpp"

/*
Function: mti_fortify_fnc_manageSavedCompositions

Description:
    Handles the dialog to rename/remove saved compositions.

Arguments:
    None

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_manageSavedCompositions;
    (end)

Author:
	Mokka
*/

// Requires ZEN
if !(isClass (configFile >> "CfgPatches" >> "zen_dialog")) exitWith {
	["Requires Zeus Enhanced to work!"] call ACE_common_fnc_displayTextStructured;
};

private _savedCompositions = profileNamespace getVariable [QGVAR(saved_compositions),createHashMap];

private _savedNames = [];
private _savedData = [];

{
    if ((count _y) != 2) then { WARNING_2("invalid data in saved compositions: %3 (idx: %2 | %1)",_x,_forEachIndex,_y); continue; };

    private _name = _x;
    private _data = _y;
    _data params ["_objects","_cost"];

    _savedNames pushBack _name;
    _savedData pushBack [_name,_objects,_cost];

    TRACE_3("checking saved compositions",_x,_name,_forEachIndex);
} forEach _savedCompositions;

if (count _savedCompositions == 0) exitWith {};

[
    "[SOB] Manage Compositions", [
        [
            "LIST",
            ["Composition", "Which composition to manage."],
            [
                _savedData,
                _savedNames,
                0
            ],
            false
        ], [
            "TOOLBOX",
            ["Action", "Select which action to perform on the selected composition."],
            [
                0,
                1,
                3,
                ["Rename","Delete","Export"]
            ],
            false
        ]
    ], {
        // on confirm
        params ["_values", "_args"];
        _values params ["_data", "_action"];
        _data params ["_name","_objects","_cost"];

        if (_data isEqualTo "") exitWith {};

        // different behaviour based on selection
        switch (_action) do {
            case 0: {
                // rename
                [
                    "[SOB] Rename Composition",
                    [
                        [
                            "EDIT",
                            ["Composition Name","This name will later show in the load display."],
                            _name,
                            true
                        ]
                    ], {
                        params ["_values", "_args"];
                        _values params ["_newName"];
                        _args params ["_name","_objects","_cost"];

                        private _savedCompositions = +(profileNamespace getVariable [QGVAR(saved_compositions),createHashMap]);
                        _savedCompositions deleteAt _name;
                        _savedCompositions set [_newName,[_objects,_cost]];
                        profileNamespace setVariable [QGVAR(saved_compositions),_savedCompositions];
                    }, {}, [_name,_objects,_cost]
                ] call zen_dialog_fnc_create;
            };
            case 1: {
                // delete
                [
                    format ["[SOB] Delete Composition: '%1'",_name],
                    [
                        [
                            "CHECKBOX",
                            ["Confirm Deletion","Please confirm the deletion of this composition."],
                            false,
                            true
                        ]
                    ], {
                        params ["_values", "_args"];
                        _values params ["_confirmed"];
                        _args params ["_name","_objects","_cost"];

                        if !(_confirmed) exitWith {[] call FUNC(manageSavedCompositions);};

                        private _savedCompositions = +(profileNamespace getVariable [QGVAR(saved_compositions),createHashMap]);
                        _savedCompositions deleteAt _name;
                        profileNamespace setVariable [QGVAR(saved_compositions),_savedCompositions];
                    }, {}, [_name,_objects,_cost]
                ] call zen_dialog_fnc_create;
            };
            case 2: {
                // export
                [
                    format ["[SOB] Export Composition: '%1'",_name],
                    [
                        [
                            "EDIT",
                            ["Name","You can rename the composition for export here."],
                            [_name],
                            true
                        ]
                    ], {
                        params ["_values", "_args"];
                        _values params ["_exportName"];
                        _args params ["_name","_objects","_cost"];

                        private _savedCompositions = +(profileNamespace getVariable [QGVAR(saved_compositions),createHashMap]);
                        private _compData = _savedCompositions get _name;

                        [_exportName,_compData] call FUNC(exportComposition);
                    }, {}, [_name,_objects,_cost]
                ] call zen_dialog_fnc_create;
            };
        };

        private _savedCompositions = +(profileNamespace getVariable [QGVAR(saved_compositions),createHashMap]);
        _savedCompositions set [_name,[_objects,_cost]];
        profileNamespace setVariable [QGVAR(saved_compositions),_savedCompositions];
    }, {
        // on cancel
    }, [], QGVAR(manageDialog)
] call zen_dialog_fnc_create;


nil
