#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Adds the child actions.
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * Actions <ARRAY>
 *
 * Example:
 * [player] call mti_fortify_fortify_fnc_addActions
 *
 * Public: No
 */

params ["_player","_thisCategory"];

_thisCategory = toLower _thisCategory;

private _presets = [_player] call FUNC(getAvailablePresets);
private _actions = [];

{
    _x params ["_classname", "_container", "_totalBudget"];

    private _displayName = getText (([_classname] call FUNC(getPresetConfig)) >> "displayName");
    private _currentBudget = [_container,_classname] call FUNC(getBudget);
    private _budget = if (_currentBudget == _totalBudget) then {format ["%1",_totalBudget]} else {format ["%1/%2",_currentBudget,_totalBudget]};
    private _category = toLower getText (([_classname] call FUNC(getPresetConfig)) >> "category");

    if (_thisCategory isNotEqualTo _category) then { continue };

    private _action = [
        _classname,
        if (_totalBudget == -1) then {_displayName} else {format ["%1 (%2)", _displayName, _budget]},
        "",
        {},
        {true},
        {_this call FUNC(addPresetActions)}, // params ["_target", "_player", "_args"];
        [_classname, _container]
    ] call ace_interact_menu_fnc_createAction;

    _actions pushBack [_action, [], _player];
} forEach _presets;

_actions
