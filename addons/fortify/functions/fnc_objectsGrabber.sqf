#include "script_component.hpp"

/*
Function: mti_fortify_fnc_objectsGrabber

Description:
    Helper function to grab nearby objects and save them in format compatible with mti_fortify_fnc_objectsMapper.
	Grabbed objects are also exported to clipboard for quick saving.

Arguments:
    _pos - Center position
	_radius - Radius
	_outputName - (optional) name of the saved composition, shown in output text

Return Value:
    Nearby objects in format [classname, relative position, azimuth, vector up, cost(, init)]

Example:
    (begin example)
        [position ACE_player,150] call mti_fortify_fnc_objectsGrabber;
    (end)

Author:
	Mokka
*/

params [["_pos",[0,0,0],[[]]], ["_radius",0,[0]], ["_name", ""]];

private _objects = [];

private _br = toString [13, 10];
private _tab = toString [9];
private _output = format ["/*%1objectGrabber Output:%1Name: %2%1*/%1%1[%1",_br,if (_name isEqualTo "") then {"Unnamed"} else {_name}];

private _objs = nearestObjects [_pos, ["All"], _radius, false];
{
    private _obj = _x;

	if (_obj isKindOf "CAManBase") then {continue};

    private _objPos = getPosATL _obj;
    private _relPos = [
        (_objPos select 0) - (_pos select 0),
        (_objPos select 1) - (_pos select 1),
        _objPos select 2
    ];

    private _azimuth = getDir _obj;
    private _vectorUp = vectorUp _obj;
    private _forceVector = false;

    if ((vectorMagnitude ((surfaceNormal (position _obj)) vectorDiff _vectorUp)) > 0.05) then {
        _forceVector = true;
    };

	private _cost = _obj getVariable [QGVAR(object_cost),0];

	private _array = [typeOf _obj, _relPos, _azimuth, _vectorUp, _cost, "", _forceVector];
    _objects pushBack _array;

	_output = _output + _tab + (str _array);
	_output = if (_forEachIndex < ((count _objs) - 1)) then {_output + ", " + _br} else {_output + _br};
} forEach _objs;

_output = _output + "]";
copyToClipboard _output;

_objects
