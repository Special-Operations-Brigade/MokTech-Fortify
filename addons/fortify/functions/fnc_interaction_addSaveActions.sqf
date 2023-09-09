#include "script_component.hpp"

/*
Function: mti_fortify_fnc_interaction_addSaveActions

Description:
    Adds save/load composition actions to suitable containers in player's vicinity.

Arguments:
    _interactionType - 0, world / 1, self

Return Value:
    None

Example:
    (begin example)
        [0] call mti_fortify_fnc_interaction_addSaveActions;
    (end)

Author:
	Mokka
*/

params ["_interactionType"];

if !(GVAR(allowSaving)) exitWith {};
if (_interactionType != 0) exitWith {};
if ((vehicle ACE_player) != ACE_player) exitWith {};

[{
    params ["_args", "_pfID"];
    _args params ["_setPosition", "_addedHelpers", "_objectsScanned", "_objectsToScanForActions"];

    if (!ace_interact_menu_keyDown) then {
        {deleteVehicle _x;} forEach _addedHelpers;
        [_pfID] call CBA_fnc_removePerFrameHandler;
    } else {
        // Prevent Rare Error when ending mission with interact key down:
        if (isNull ACE_player) exitWith {};

        //For performance, we only do 1 thing per frame,
        //-either do a wide scan and search for objects with actions
        //-or scan one object at a time and add the actions for that object

        if (_objectsToScanForActions isEqualTo []) then {
            //If player moved >2 meters from last pos, then rescan
            if (((getPosASL ACE_player) distance _setPosition) < 2) exitWith {};

            private _nearObjects = nearestObjects [ACE_player, ["ALL"], 30];

            {
                private _objectConfig = configOf _x;
                if ((_x getVariable [QGVAR(saveActions_added),false]) || {_x getVariable [QGVAR(canSave),false]} || {GET_NUMBER(_objectConfig >> QGVAR(canSave),0) == 0}) then {
                    _objectsScanned pushBack _x;
                } else {
                    _objectsToScanForActions pushBack _x;
                };
            } forEach (_nearObjects - _objectsScanned);

            _args set [0, (getPosASL ACE_player)];
        } else {
            private _objectBeingScanned = _objectsToScanForActions deleteAt 0;
            // Skip this object for now if we are outside of it's radius
            // (we have to scan far out for the big objects, but we don't want to waste time adding actions on every little shack)
            if ((_objectBeingScanned != cursorTarget) && {((ACE_player distance _objectBeingScanned) - ((boundingBoxReal _objectBeingScanned) select 2)) > 4}) exitWith {};

            // compile and add actions
            private _action = [
                QGVAR(save_parentAction),
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
            [_objectBeingScanned,0,["ACE_MainActions"],_action] call ACE_interact_menu_fnc_addActionToObject;

            _action = [
                QGVAR(saveAction),
                "Save Composition",
                "", // icontodo
                {_this call FUNC(saveComposition)},
                {
                    params ["_target", "_player", "_args"];

                    private _totalCount = 0;
                    private _radius = _target getVariable QGVAR(saveRange);
                    if (isNil "_radius") then {_radius = GET_NUMBER((configOf _target) >> QGVAR(saveRange),CONST_DEFAULT_SAVE_RADIUS)};

                    {
                        private _cost = _x getVariable QGVAR(object_cost);
                        if !(isNil "_cost") then { _totalCount = _totalCount + 1; };
                    } forEach ((position _target) nearObjects ["All",_radius]);

                    (_totalCount > 0)
                },
                nil,nil,nil,
                10
            ] call ace_interact_menu_fnc_createAction;
            [_objectBeingScanned,0,["ACE_MainActions",QGVAR(save_parentAction)],_action] call ACE_interact_menu_fnc_addActionToObject;

            _action = [
                QGVAR(loadAction),
                "Load Composition",
                "", // icontodo
                {_this call FUNC(loadComposition)},
                {
                    params ["_target", "_player", "_args"];

                    private _used = _target getVariable [QGVAR(used),false];

                    !(_used)
                },
                nil,nil,nil,
                10
            ] call ace_interact_menu_fnc_createAction;
            [_objectBeingScanned,0,["ACE_MainActions",QGVAR(save_parentAction)],_action] call ACE_interact_menu_fnc_addActionToObject;

            TRACE_2("Add Actions for [%1] @ %2",typeOf _objectBeingScanned,diag_tickTime);
            _objectsScanned pushBack _objectBeingScanned;
            _objectBeingScanned setVariable [QGVAR(saveActions_added),true];
        };
    };
}, 0, [((getPosASL ACE_player) vectorAdd [-100,0,0]), [], [], []]] call CBA_fnc_addPerFrameHandler;
