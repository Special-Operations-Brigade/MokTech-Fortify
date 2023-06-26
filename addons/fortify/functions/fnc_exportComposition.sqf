#include "script_component.hpp"

/*
Function: mti_fortify_fortify_fnc_exportComposition

Description:
    Exports the given composition to clipboard.

Arguments:
    _name - Name to use on export
    _data - Composition data

Return Value:
    Composition in string format

Example:
    (begin example)
        [ace_player] call mti_fortify_fortify_fnc_exportComposition;
    (end)

Author:
	Mokka
*/

params ["_name", "_data"];

private _br = toString [13, 10];
private _tab = toString [9];
private _output = format ["/*%1Composition Export:%1%2Name: %3%1%2Cost: %4%1*/%1%1[%1",_br,_tab,if (_name isEqualTo "") then {"Unnamed"} else {_name},(_data select 1)];

{
	_output = _output + _tab + (str _x);
	_output = if (_forEachIndex < ((count (_data select 0)) - 1)) then {_output + ", " + _br} else {_output + _br};
} forEach (_data select 0);

_output = _output + "]";
copyToClipboard _output;

[format ["Composition %1 was exported to clipboard!"]] call ACE_common_fnc_displayTextStructured;

_output
