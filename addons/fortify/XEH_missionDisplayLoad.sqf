#include "script_component.hpp"

if (!hasInterface) exitWith {};

params ["_display"];

_display displayAddEventHandler ["MouseZChanged", {
    (_this select 1) call FUNC(handleScrollWheel);
}];

_display displayAddEventHandler ["MouseButtonDown", {
    if (GVAR(isPlacing) != PLACE_WAITING) exitWith {false};
    if ((_this select 1) != 1) exitWith {false};
    GVAR(isPlacing) = PLACE_CANCEL
}];

_display displayAddEventHandler ["KeyDown", {
    if (GVAR(isPlacing) != PLACE_WAITING) exitWith {false};
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];
    private _block = false;

    if (_key == DIK_ADD) then {
        GVAR(distanceOffset) = GVAR(distanceOffset) + DISTANCE_OFFSET_MOD;
        _block = true;
    };
    if (_key == DIK_SUBTRACT) then {
        GVAR(distanceOffset) = GVAR(distanceOffset) - DISTANCE_OFFSET_MOD;
        _block = true;
    };

    _block
}];
