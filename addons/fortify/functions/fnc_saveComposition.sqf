#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_saveComposition

Description:
    Handles saving nearby deployed objects into a composition

Arguments:
    ACE Action Arguments

Return Value:
    None

Example:
    (begin example)
        [...] call mti_fortify_fortify_fnc_saveComposition;
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

private _containerPos = position _target;

// collect objects worth saving
private _objects = [];
private _totalCost = 0;

{
    private _cost = _x getVariable QGVAR(object_cost);

    if !(isNil "_cost") then {
        if (_cost == -1) then { _cost = 0; };

        if ((_totalCost + _cost) > _maxBudget) exitWith {
            ["Total cost of nearby objects exceeds max. save budget!<br/>Saved composition might be truncated.",4] call ACE_common_fnc_displayTextStructured;
        };

        _totalCost = _totalCost + _cost;
        _objects pushback [_x,_cost];
    };
} forEach (nearestObjects [position _target, ["All"], _radius, false]);

private _objectsMapped = _objects apply {
    _x params ["_obj","_cost"];
    private _objPos = getPosATL _obj;
    private _relPos = [
        (_objPos select 0) - (_containerPos select 0),
        (_objPos select 1) - (_containerPos select 1),
        _objPos select 2
    ];

    private _azimuth = getDir _obj;
    private _vectorUp = vectorUp _obj;
    private _forceVector = false;

    if ((vectorMagnitude ((surfaceNormal (position _obj)) vectorDiff _vectorUp)) > 0.05) then {
        _forceVector = true;
    };

    [typeOf _obj, _relPos, _azimuth, _vectorUp, _cost, "", _forceVector];
};

[
    format ["[SOB] Save Composition (Total Cost: %1)",_totalCost], [
        [
            "EDIT",
            ["Composition Name", "This name will later show in the load display."],
            "",
            true
        ]
    ], {
        // on confirm
        params ["_values", "_args"];
        _values params ["_saveName"];
        _args params ["_objectsMapped","_totalCost"];

        private _savedCompositions = +(profileNamespace getVariable [QGVAR(saved_compositions),createHashMap]);
        _savedCompositions set [_saveName,[_objectsMapped,_totalCost]];
        profileNamespace setVariable [QGVAR(saved_compositions),_savedCompositions];

        [format["Composition was saved as '%1'<br/>Object count: %2<br/>Total Cost: %3",_saveName,count _objectsMapped,_totalCost],5] call ACE_common_fnc_displayTextStructured;
    }, {
        // on cancel
    }, [_objectsMapped,_totalCost], QGVAR(saveDialog)
] call zen_dialog_fnc_create;

nil
