#include "script_component.hpp"

/*
Function: mti_fortify_fnc_compositionDeployCanceled

Description:
    Resets values after composition deploy was cancelled.

Arguments:
    ...

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_compositionDeployCanceled;
    (end)

Author:
	Mokka
*/

params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
_args params ["_unit", "_container", "_objects", "_posASL", "_azimuth", "_cost", "_marker"];

// Refund if deploy was cancelled
[_container, _cost] call FUNC(updateCompositionBudget);

// Reset animation
[_unit, "", 2] call ace_common_fnc_doAnimation;
