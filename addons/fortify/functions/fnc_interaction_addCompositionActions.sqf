#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_interaction_addCompositionActions

Description:
    Adds composition actions to suitable containers in player's vicinity.

Arguments:
    _interactionType - 0, world / 1, self

Return Value:
    None

Example:
    (begin example)
        [0] call mti_fortify_fortify_fnc_interaction_addCompositionActions;
    (end)

Author:
	Mokka
*/

params ["_interactionType"];

if !(GVAR(fortifyAllowed)) exitWith {};
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
				private _actionsAdded = _x getVariable [QGVAR(compositionActions_added),false];
				private _compositionCount = count (_x getVariable [QGVAR(availableCompositions),[]]);
				if (_compositionCount == 0) then { _compositionCount = count (GET_ARRAY(_objectConfig >> QGVAR(availableCompositions),[])); };

				TRACE_3("looking for objects",_objectConfig,_actionsAdded,_compositionCount);

                if (_actionsAdded || {_compositionCount == 0}) then {
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
            private _maxBudget = _objectBeingScanned getVariable QGVAR(compositionBudget);
            if (isNil "_maxBudget") then { _maxBudget = GET_NUMBER(configFile >> "CfgVehicles" >> (typeOf _objectBeingScanned) >> QGVAR(compositionBudget),CONST_DEFAULT_COMPOSITION_BUDGET); };
			TRACE_1("retrieving config data",_maxBudget);

			private _action = [
                QGVAR(composition_parentAction),
                "Compositions",
                "", // icontodo
                {},
                {
                    params ["_target", "_player", "_args"];

                    private _canFortify = [_player] call FUNC(canFortify);
                    TRACE_1("can fortify?",_canFortify);

                    (_canFortify)
                },
                nil,[_maxBudget],nil,10,nil,
				{
					params ["_target", "_player", "_args", "_actionData"];
					_args params ["_maxBudget"];

					private _budget = [_target] call FUNC(getCompositionBudget);

					if (_budget != -1) then {
						_actionData set [1,format["Compositions (%1/%2)",_budget,_maxBudget]];
					} else {
						_actionData set [1,"Compositions"];
					};
				}
            ] call ace_interact_menu_fnc_createAction;
            [_objectBeingScanned,0,["ACE_MainActions"],_action] call ACE_interact_menu_fnc_addActionToObject;

            private _compositions = _objectBeingScanned getVariable QGVAR(availableCompositions);
            if (isNil "_compositions") then { _compositions = GET_ARRAY((configOf _objectBeingScanned) >> QGVAR(availableCompositions),[]) };
			TRACE_1("retrieving config data",_compositions);
            _compositions = _compositions select {
                private _scope = GET_NUMBER(([_x] call FUNC(getCompositionConfig)) >> "scope",0);
                TRACE_2("sanitizing",_x,_scope);
                (_scope > 0)
            };
			TRACE_1("after clean-up",_compositions);

			{
				private _config = [_x] call FUNC(getCompositionConfig);
                private _name = GET_TEXT(_config >> "displayName","");
				private _cost = GET_NUMBER(_config >> "cost",0);

				if (_cost > 0) then { _name = format ["%1 (%2)",_name,_cost]; };

				private _deployAction = [
					format [QGVAR(deploy_%1),_forEachIndex],
					format ["Deploy %1",_name],
					"", // icontodo
					{_this call FUNC(deployComposition)},
					{true},
					nil,[_objectBeingScanned,_x,_name,_cost],nil,10,nil,
					{
						params ["_target", "_player", "_args", "_actionData"];
						_args params ["_container","_classname","_name","_cost"];

						private _budget = [_target] call FUNC(getCompositionBudget);

    					if !((_budget == -1) || {_budget >= _cost}) then {
    					    _name = format ["<t color='#ff0000'>%1</t>",_name];
    					};

						_actionData set [1,_name];
					}
				] call ace_interact_menu_fnc_createAction;

				[_objectBeingScanned,0,["ACE_MainActions",QGVAR(composition_parentAction)],_deployAction] call ACE_interact_menu_fnc_addActionToObject;
			} forEach _compositions;

            _action = [
                QGVAR(recallAll),
                "Recall All",
                "", // icontodo
                {_this call FUNC(recallAllCompositions)},
                {
                    params ["_target", "_player", "_args"];

                    private _deployedObjects = _target getVariable QGVAR(deployedCompositionObjects);
					TRACE_1("checking deployed",_deployedObjects);

                    (!(isNil "_deployedObjects") && {(count _deployedObjects) > 0})
                },
                nil,nil,[],
                10
            ] call ace_interact_menu_fnc_createAction;
            [_objectBeingScanned,0,["ACE_MainActions",QGVAR(composition_parentAction)],_action] call ACE_interact_menu_fnc_addActionToObject;

            TRACE_2("Add Actions for [%1] @ %2",typeOf _objectBeingScanned,diag_tickTime);

			_objectsScanned pushBack _objectBeingScanned;
			_objectBeingScanned setVariable [QGVAR(compositionActions_added),true];
        };
    };
}, 0, [((getPosASL ACE_player) vectorAdd [-100,0,0]), [], [], []]] call CBA_fnc_addPerFrameHandler;
