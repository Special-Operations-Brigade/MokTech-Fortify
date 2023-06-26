#define COMPONENT fortify
#define COMPONENT_BEAUTIFIED Fortify
#include "\z\mti_fortify\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_FORTIFY
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_FORTIFY
    #define DEBUG_SETTINGS DEBUG_SETTINGS_FORTIFY
#endif

#include "\z\mti_fortify\addons\main\script_macros.hpp"

#define CONTAINER_SEARCH_RADIUS 150
#define CONTAINER_SEARCH_TIMEOUT 5.0

#define DISTANCE_OFFSET_MOD 0.1
#define DISTANCE_MIN 1
#define DISTANCE_MAX 20

#define CONST_DEFAULT_SAVE_RADIUS 100
#define CONST_DEFAULT_SAVE_MAXBUDGET 2500
#define CONST_DEFAULT_COMPOSITION_BUDGET 2500

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

#define PLACE_WAITING -1
#define PLACE_CANCEL 0
#define PLACE_APPROVE 1


#define MACRO_FNC_MULTIPLYMATRIX private _fnc_multiplyMatrix = {\
	params ["_array1","_array2"];\
	private _result = [\
		(((_array1 select 0) select 0) * (_array2 select 0)) + (((_array1 select 0) select 1) * (_array2 select 1)),\
		(((_array1 select 1) select 0) * (_array2 select 0)) + (((_array1 select 1) select 1) * (_array2 select 1))\
	];\
	_result\
}
