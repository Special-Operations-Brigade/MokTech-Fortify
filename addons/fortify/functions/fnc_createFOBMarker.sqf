#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_createFOBMarker

Description:
    Creates a FOB marker on the given target's position.

Arguments:
    _player
    _target

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fortify_fnc_createFOBMarker;
    (end)

Author:
	Mokka
*/

params ["_player","_target"];

// Requires ZEN
if !(isClass (configFile >> "CfgPatches" >> "zen_dialog")) exitWith {
	["Requires Zeus Enhanced to work!"] call ACE_common_fnc_displayTextStructured;
};

private _markerTypes = [] call FUNC(getMarkerTypes);
private _markerColours = [] call FUNC(getMarkerColours);

[
    "[SOB] Create FOB Marker", [
        [
            "EDIT",
            ["Name", "This name will be displayed on the marker."],
            "",
            true
        ], [
            "LIST",
            ["Marker Type", "Which style of icon to use."],
            [
                (_markerTypes select 0),
                (_markerTypes select 1),
                0
            ],
            false
        ], [
            "LIST",
            ["Marker Colour", "Which colour to use for the marker."],
            [
                (_markerColours select 0),
                (_markerColours select 1),
                0
            ],
            false
        ]
    ], {
        // on confirm
        params ["_values", "_args"];
        _values params ["_name", "_type", "_color"];
        _args params ["_player", "_target"];

		private _marker = createMarker [format[QGVAR(FOBMarker_%1),round CBA_missionTime], position _target, 1, _player];
		_marker setMarkerTypeLocal _type;
		_marker setMarkerColorLocal _color;
        _marker setMarkerTextLocal _name;
		_marker setMarkerPos (position _target);

		_target setVariable [QGVAR(FOBMarker),_marker,true];

        ["Marker Created"] call ACE_common_fnc_displayTextStructured;

		[
			{
				!(alive (_this select 0))
			}, {
				deleteMarker (_this select 1);
			}, [_target,_marker]
		] call CBA_fnc_waitUntilAndExecute;
    }, {
        // on cancel
    }, [_player,_target], QGVAR(FOBMarker_dialog)
] call zen_dialog_fnc_create;
