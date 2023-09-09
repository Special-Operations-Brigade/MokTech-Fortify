#include "script_component.hpp"

/*
Function: mti_fortify_fnc_addContainerActions

Description:
    Adds ace interactions to container.

Arguments:
    _container
    _preset

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_addContainerActions;
    (end)

Author:
	Mokka
*/

params ["_container","_preset"];
TRACE_2("containerActions",_container,_preset);

if (_container isEqualTo ACE_player) exitWith {};

private _actionList = _container getVariable "ace_interact_menu_actions";
if (isNil "_actionList") then {
    _actionList = [];
};

// gonna remove this for now, just gotta take care of proper main action in the container config itself
/*
private _mainNode = [_actionList, ["ACE_MainActions"]] call ace_interact_menu_fnc_findActionNode;

TRACE_1("mainNode",_mainNode);

if (isNil {_mainNode}) then {
    TRACE_1("No Main Action on object", _container);

    private _mainAction = [
        "ACE_MainActions",
        "Interactions",
        "",
        {},
        {true},
        nil,nil,nil,
        10
    ] call ace_interact_menu_fnc_createAction;

    private _jipID = [QGVAR(ace_addActionToObject),[_container,0,[],_mainAction]] call CBA_fnc_globalEventJIP;
    [_jipID,_container] call CBA_fnc_removeGlobalEventJIP; // todo: may have to move this to server exec?!
};

*/

private _parentAction = [_actionList,[QGVAR(parentAction)]] call ace_interact_menu_fnc_findActionNode;

TRACE_1("parentAction",_parentAction);

if (isNil {_parentAction}) then {
    _parentAction = [
        QGVAR(parentAction),
        "Fortify",
        "", // icontodo
        {},
        {
            params ["_target", "_player", "_args"];

            private _canFortify = [_player] call FUNC(canFortify);
            TRACE_1("can fortify?",_canFortify);

            (_canFortify)
        },
        nil,nil,nil,
        10
    ] call ace_interact_menu_fnc_createAction;

    private _jipID = [QGVAR(ace_addActionToObject),[_container,0,["ACE_MainActions"],_parentAction]] call CBA_fnc_globalEventJIP;
    [_jipID,_container] call CBA_fnc_removeGlobalEventJIP; // todo: may have to move this to server exec?!
};

private _presetAction = [_actionList,[format[QGVAR(presetAction_%1),_preset]]] call ace_interact_menu_fnc_findActionNode;

TRACE_1("presetAction",_presetAction);

if (isNil {_presetAction}) then {
    private _displayName = getText (([_preset] call FUNC(getPresetConfig)) >> "displayName");

    _presetAction = [
        format[QGVAR(presetAction_%1),_preset],
        _displayName,
        "", // icontodo
        {},
        {
            params ["_target", "_player", "_args"];
            _args params ["_container","_preset"];

            private _deployedObjects = _container getVariable [(format[QGVAR(deployedObjects_%1),_preset]),[]];
            private _total = 0;
            { _total = _total + (_y select 0); } forEach _deployedObjects;

            TRACE_2("has objects?",_preset,_total);

            (_total > 0)
        },
        {},
        [_container,_preset,_displayName],
        nil,
        10,
        nil,
        {
            params ["_target", "_player", "_args", "_actionData"];
            _args params ["_container", "_preset", "_displayName"];

            private _budget = [_container, _preset] call FUNC(getBudget);
            if (_budget >= 0) then { _displayName = format ["%1 (%2)",_displayName,_budget]; };

            _actionData set [1, _displayName];
        }
    ] call ace_interact_menu_fnc_createAction;

    private _jipID = [QGVAR(ace_addActionToObject),[_container,0,["ACE_MainActions",QGVAR(parentAction)],_presetAction]] call CBA_fnc_globalEventJIP;
    [_jipID,_container] call CBA_fnc_removeGlobalEventJIP; // todo: may have to move this to server exec?!

    private _recallAction = [
        "recallAll",
        "Recall All Objects",
        "", // icontodo
        {_this call FUNC(recallAllObjects)},
        {true},
        {},
        [_container,_preset],
        nil,
        10
    ] call ace_interact_menu_fnc_createAction;

    _jipID = [QGVAR(ace_addActionToObject),[_container,0,["ACE_MainActions",QGVAR(parentAction),format[QGVAR(presetAction_%1),_preset]],_recallAction]] call CBA_fnc_globalEventJIP;
    [_jipID,_container] call CBA_fnc_removeGlobalEventJIP; // todo: may have to move this to server exec?!

    /*
        todo: figure out any additional actions I might want here...
        ideas:
            - highlight objects deployed from this container
    */
};
