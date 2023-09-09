// COMPONENT should be defined in the script_component.hpp and included BEFORE this hpp

#define MAINPREFIX z
#define PREFIX mti

#define AUTHOR QUOTE(MokTech Industries)
#define MOD_NAME_BEAUTIFIED QUOTE(MokTech Industries - Fortify)

#include "script_version.hpp"

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR  MAJOR,MINOR,PATCHLVL,BUILD

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 2.06
#define REQUIRED_CBA_VERSION {3,15,6}
#define REQUIRED_ACE_VERSION {3,14,0,63}

#define RELEASE_BUILD

#ifndef RELEASE_BUILD
    #define DEBUG_ENABLED_FORTIFY
#endif

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(MokTech Industries - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(MokTech Industries - COMPONENT)
#endif
