#include "script_component.hpp"
/*
	File: objectMapper.sqf
	Author: Joris-Jan van 't Land
	Modified by: Mokka
	Description:
	Takes an array of data about a dynamic object template and creates the objects.
	Parameter(s):
	_this select 0: position of the template - Array [X, Y, Z]
	_this select 1: azimuth of the template in degrees - Number
	_this select 2: objects for the template - Array / composition class - String / tag list - Array
	_this select 3: (optional) create locally? - Boolean
	_this select 4: (optional) create as simple objects? - Boolean
	_this select 5: (optional) align to ground? - Boolean
	Returns:
	Created objects (Array)
*/

params [
	["_pos", [0, 0], [[]]],
	["_azi", 0, [-1]],
	["_objs", [], [[]]],
	["_local", false],
	["_simple", false],
	["_groundAlign", false]
];

//Make sure there are definitions in the final object array
if ((count _objs) == 0) exitWith {WARNING_1("no objects in composition array!",_this); []};

private _newObjs = [];

_pos params ["_posX","_posY"];

MACRO_FNC_MULTIPLYMATRIX;

{
	_x params [
		"_type", "_relPos", "_azimuth", "_vectorUp", "_cost", ["_init",""], ["_forceVectorUp",false]
	];
	TRACE_7("object entry",_type,_relPos,_azimuth,_vectorUp,_cost,_init,_forceVectorUp);

	//Rotate the relative position using a rotation matrix
	private _rotMatrix = [
		[cos _azi, sin _azi],
		[-(sin _azi), cos _azi]
	];

	//Backwards compatability causes for height to be optional
	private _z = 0;
	if ((count _relPos) > 2) then { _z = _relPos select 2; };

	private _newRelPos = [_rotMatrix,_relPos] call _fnc_multiplyMatrix;
	private _newPos = [_posX + (_newRelPos select 0), _posY + (_newRelPos select 1), _z];

	TRACE_5("position calculated",_newRelPos,_newPos,_relPos,_pos,_rotMatrix);

	//Create the object and make sure it's in the correct location
	private ["_newObj"];
	if (_simple) then {
		_newObj = createSimpleObject [_type, _newPos, _local];
	} else {
		if (_local) then {
			_newObj = _type createVehicleLocal _newPos;
		} else {
			_newObj = createVehicle [_type, _newPos, [], 0, "CAN_COLLIDE"];
		};
	};

	_newObj setDir (_azi + _azimuth);

	if (_groundAlign && !(_forceVectorUp)) then {
		_newObj setVectorUp (surfaceNormal (position _newObj));
	} else {
		_newObj setVectorUp _vectorUp;
	};

	if ((_init isNotEqualTo "") && {(not _simple) && (not _local)}) then {_newObj call (compile ("this = _this; " + _init));};

	if (_simple) then {
		_newObj enableSimulation false;
		_newObj allowDamage false;
	};

	if (_local) then {
		_newObj disableCollisionWith ACE_player;
	};

	_newObj setVariable [QGVAR(objMapper_relPos),_relPos, !(_local)];
	_newObj setVariable [QGVAR(objMapper_vectorUp),_vectorUp, !(_local)];
	_newObj setVariable [QGVAR(objMapper_azimuth),_azimuth, !(_local)];

	_newObjs pushBack _newObj;
} forEach _objs;

_newObjs