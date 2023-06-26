#include "script_component.hpp"

/*
Function: mti_common_fnc_clamp

Description:
    Clamps given numerical value between min and max.

Arguments:
    _value - Value to clamp
    _min - Min value (inclusive)
    _max - Max Value (inclusive)

Return Value:
    Clamped value

Example:
    (begin example)
        [1.2, 0, 1] call mti_common_fnc_clamp;
    (end)

Author:
	Mokka
*/

params [["_value",0,[0]],["_min",-1,[0]],["_max",1,[0]]];

if (_min > _max) exitWith { WARNING_2("clamp min %1 should be greater than or equal to clamp max %2",_min,_max); };

if (_value < _min) then { _value = _min; };
if (_value > _max) then { _value = _max; };

_value
