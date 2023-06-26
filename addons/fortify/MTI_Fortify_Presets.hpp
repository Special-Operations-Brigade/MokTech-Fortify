/*
This class contains presets for the fortify system. Containers and backpacks still need to be "assigned" to a preset:

(begin example)
    class MTI_Fortify_Presets {
        class Default;
        class Example_Preset: Default {
            scope = 1;
            displayName = "My Example Preset";
            class Objects {
                class _xx_3AS_Barricade_prop {
                    name = "3AS_Barricade_prop";
                    cost = 20;
                    limit = -1;
                };
            };
        };
    };

    class CfgVehicles {
        class My_Container {
            //....
            mti_fortify_availablePresets[] = { "Example_Preset", 1000 }; // presets in format: <class name>, <total budget>
        };
    };
(end example)

A container can have more than one preset available, budgets are always handled individually for each preset.
Make sure you always have a preset's class-name immediately followed by that preset's initial budget.

In order for a player to be able to use the Fortify system, they need a backpack with the following config parameters added to it:
(begin example)
    class CfgVehicles {
        class My_Backpack {
            //....
            mti_fortify_canFortify = 1; // <-- enables player access the fortify menu

            // optional, if you want players to be able to deploy things directly from backpack without container:
            mti_fortify_availablePresets[] = { "Example_Backpack_Preset", 250 }; // presets in format: <class name>, <total budget>
        };
    };
(end example)

Additionally, you can designate a special type of container that allows players to save their creations (and load them again on another mission).
This requires you to add at least the canSave option to the container's config (see below).
You can control max. budget and range of the container through the config as well, but those are not required (budget defaults to 2500, range to 100).

(begin example)
    class CfgVehicles {
        class My_Save_Container {
            //....
            mti_fortify_canSave = 1; // <-- enables saving nearby deployed objects into a composition, required
            mti_fortify_saveMaxBudget = 2500; // <-- controls how many objects (based on cost) the container can save, optional
            mti_fortify_saveRange = 100; // <-- controls how far out objects can be in order for them to get saved, optional
        };
    };
(end example)

Presets can also be defined in missionConfigFile (through description.ext). If missionConfig and addonConfig both contain a class of the same name, the one from missionConfig will be used.

Using setVariable, any object can be made into a container through means of scripting. The relevant variables to set are outlined below. Please note that using setVariable OVERWRITES the container settings found in config!
Important note, please make sure that you follow the same format for availablePresets as in config. That is: a preset is always immediately followed by that preset's budget.

(begin example)
    // let _this be an object
    _this setVariable ["mti_fortify_availablePresets", ["Example_Preset",250], true];
(end example)

Similarly, arbitrary objects can be turned into save/load containers using setVariable, using the following variables:

(begin example)
    // let _this be an object
    _this setVariable ["mti_fortify_canSave", true, true];
    _this setVariable ["mti_fortify_saveMaxBudget", 2500, true];
    _this setVariable ["mti_fortify_saveRange", 100, true];
(end example)
*/

class GVAR(Presets) {
    class Default {
        scope = 0;                                  // controls visibility of the preset, scope > 0 makes it visible
        displayName = "";                           // The name of the preset, displayed in the fortify interaction menu
        backpackOnly = 0;                           // if this is 1, this preset can only be used with backpacks
        category = "";                              // Presets can be assigned to a category which will make the ace menu less cluttered
        class Objects {                             // this sub-class contains all objects (from CfgVehicles) that are available in this preset
            // MACRO_FORTIFY_ADD(CLASSNAME,COST,LIMIT)
        };
    };

// Example presets below
/*
    class Backpack_Default: Default {
        scope = 1;
        displayName = "FS-B Internal";
        backpackOnly = 1;
        class Objects {
            MACRO_FORTIFY_ADD(3AS_Barricade_prop,20,-1);
            MACRO_FORTIFY_ADD(3AS_Barricade_2_C_prop,20,-1);
            MACRO_FORTIFY_ADD(3AS_Barricade_3_prop,20,-1);
            MACRO_FORTIFY_ADD(3AS_Barricade_Cover_2_Prop,10,-1);
            MACRO_FORTIFY_ADD(3AS_Cover1,10,-1);
            MACRO_FORTIFY_ADD(JLTS_portable_shield_gar,50,1);
            MACRO_FORTIFY_ADD(ACE_TacticalLadder,25,2); // todo: make version of tactical ladder without "pick up" action?
        };
    };

    class Fortifications_Small: Default {
        scope = 1;
        displayName = "Fortifications (Small)";
        category = "Fortifications";
        class Objects {
            MACRO_FORTIFY_ADD(3AS_Shield_3_prop,10,-1);
            MACRO_FORTIFY_ADD(3AS_Shield_5_prop,15,-1);
            MACRO_FORTIFY_ADD(3AS_Shield_C_prop,20,-1);
            MACRO_FORTIFY_ADD(3AS_Shield_1_prop,5,-1);
            MACRO_FORTIFY_ADD(3AS_Short_Wall,10,-1);
            MACRO_FORTIFY_ADD(3AS_Short_Wall_Curved,20,-1);
            MACRO_FORTIFY_ADD(3AS_Short_Wall_Long,20,-1);
            MACRO_FORTIFY_ADD(3AS_Short_Wall_Post,10,-1);
        };
    };

    class Fortifications_Medium: Default {
        scope = 1;
        displayName = "Fortifications (Medium)";
        category = "Fortifications";
        class Objects {
            MACRO_FORTIFY_ADD(3AS_Short_Wall_Bunker,20,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_1,10,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_3,15,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_5,20,-1);
            MACRO_FORTIFY_ADD(3as_FOB_Light_Tall_Prop,15,-1);
            MACRO_FORTIFY_ADD(ls_stone_cover,10,-1);
            MACRO_FORTIFY_ADD(PARACHUTE_TARGET,10,-1);
        };
    };

    class Fortifications_Large: Default {
        scope = 1;
        displayName = "Fortifications (Large)";
        category = "Fortifications";
        class Objects {
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierBig_1,5,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierBig_4,15,-1);
            MACRO_FORTIFY_ADD(3AS_Tent_Med,25,-1);
            MACRO_FORTIFY_ADD(land_3as_Bunker_Metal,25,-1);
            MACRO_FORTIFY_ADD(land_3as_Bunker_Metal_Command,30,-1);
            MACRO_FORTIFY_ADD(3as_Metal_Trench_Corner,10,-1);
            MACRO_FORTIFY_ADD(3as_Metal_Trench_Long_Single,20,-1);
            MACRO_FORTIFY_ADD(3as_Metal_Trench_Long,20,-1);
            MACRO_FORTIFY_ADD(3as_Metal_Trench_Short_Single,10,-1);
            MACRO_FORTIFY_ADD(3as_Metal_Trench_Short,10,-1);
            MACRO_FORTIFY_ADD(3as_Metal_Trench_T,15,-1);
            MACRO_FORTIFY_ADD(3as_Metal_Trench_X,15,-1);
            MACRO_FORTIFY_ADD(PARACHUTE_TARGET,10,-1);
            MACRO_FORTIFY_ADD(3as_FOB_Light_Tall_Prop,15,-1);
        };
    };

    class FOB_Walls: Default {
        scope = 1;
        displayName = "FOB Walls";
        category = "FOB_Parts";
        class Objects {
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_bunker,25,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_watchtower,25,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_watchtower,25,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_door,25,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_corner_inversed,20,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_corner,20,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_gate,30,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_ramp,10,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_straight_long,20,-1);
            MACRO_FORTIFY_ADD(3as_prop_fob_modular_wall_straight,10,-1);
        };
    };

    class FOB_HBarrier: Default {
        scope = 1;
        displayName = "FOB H-Barriers";
        category = "FOB_Parts";
        class Objects {
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_1,5,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_3,10,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_5,15,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierBig_1,10,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierBig_4,15,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_corridor,20,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrier_ramp,20,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierWall_ramp,20,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierWall_4,20,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierWall_7,25,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierWall_exvertedCorner,25,-1);
            MACRO_FORTIFY_ADD(Land_lsb_fob_hBarrierWall_invertedCorner,25,-1);
        };
    };

    class FOB_Objects: Default {
        scope = 1;
        displayName = "FOB Objects";
        category = "FOB_Parts";
        class Objects {
            MACRO_FORTIFY_ADD(3as_FOB_Light_Tall_Prop,15,-1);
            MACRO_FORTIFY_ADD(PARACHUTE_TARGET,10,-1);
            MACRO_FORTIFY_ADD(3AS_Tent_Med,15,2);
            MACRO_FORTIFY_ADD(MTI_FuelCanister_Large,25,-1);
            MACRO_FORTIFY_ADD(3as_FOB_Building_1_prop,30,1);
            MACRO_FORTIFY_ADD(3as_FOB_Building_2_prop,30,1);
            MACRO_FORTIFY_ADD(GVAR(FOB_core),30,1);
        };
    };

    class FOB_Decorations_Large: Default {
        scope = 1;
        displayName = "FOB Decorations (Large)";
        category = "FOB_Parts";
        class Objects {
            MACRO_FORTIFY_ADD(3as_large_crate_prop,15,-1);
            MACRO_FORTIFY_ADD(3as_large_crate_stack_1_prop,15,-1);
            MACRO_FORTIFY_ADD(3as_large_crate_stack_2_prop,15,-1);
            MACRO_FORTIFY_ADD(3as_large_crate_stack_3_prop,15,-1);
            MACRO_FORTIFY_ADD(3as_small_crate_prop,15,-1);
            MACRO_FORTIFY_ADD(3as_small_crate_stack_1_prop,15,-1);
            MACRO_FORTIFY_ADD(3as_small_crate_stack_2_prop,15,-1);
        };
    };

    class FOB_Decorations_Small: Default {
        scope = 1;
        displayName = "FOB Decorations (Small)";
        category = "FOB_Parts";
        class Objects {
            MACRO_FORTIFY_ADD(3AS_TERMINAL_2_PROP,10,-1);
            MACRO_FORTIFY_ADD(3AS_TERMINAL_1_PROP,10,-1);
            MACRO_FORTIFY_ADD(3AS_TERMINAL_Screen_PROP,10,-1: Default);
            MACRO_FORTIFY_ADD(3AS_Terminal_Console_Prop,10,-1);
            MACRO_FORTIFY_ADD(3AS_Terminal_Console_Med_Prop,10,-1);
            MACRO_FORTIFY_ADD(mti_props_crate_double_closed,10,-1);
            MACRO_FORTIFY_ADD(mti_props_crate_double_open,10,-1);
            MACRO_FORTIFY_ADD(mti_props_crate_single_closed,10,-1);
            MACRO_FORTIFY_ADD(mti_props_crate_single_open,10,-1);
            MACRO_FORTIFY_ADD(ls_flag_standardRepublic,10,-1);
        };
    };

    class LaserWalls: Default {
        scope = 1;
        displayName = "Laser Walls";
        category = "FOB_Parts";
        class Objects {
            MACRO_FORTIFY_ADD(3AS_Wall_Laser,15,-1);
            MACRO_FORTIFY_ADD(land_3AS_Wall_Laser_v2,15,-1);
            MACRO_FORTIFY_ADD(3AS_Wall_Laser_Corner,15,-1);
            MACRO_FORTIFY_ADD(land_3AS_Wall_Laser_Corner,15,-1);
            MACRO_FORTIFY_ADD(3AS_Wall_Laser_Door,15,-1);
            MACRO_FORTIFY_ADD(land_3AS_Wall_Laser_Door_v2,15,-1);
            MACRO_FORTIFY_ADD(land_3AS_Imperial_Checkpoint,25,-1);
            MACRO_FORTIFY_ADD(land_3AS_Imperial_Checkpoint_Long,35,-1);
        };
    };

    class BARC_Speeders: Default {
        scope = 1;
        displayName = "BARC Speeders";
        category = "Misc";
        class Objects {
            MACRO_FORTIFY_ADD(MTI_Barc,50,-1);
            MACRO_FORTIFY_ADD(MTI_Barc_Stretcher,50,-1);
        };
    };

    class Mortars: Default {
        scope = 1;
        displayName = "Mortars";
        category = "Statics";
        class Objects {
            MACRO_FORTIFY_ADD(MTI_Mortar,50,-1);
        };
    };

    class HeavyRepeaters: Default {
        scope = 1;
        displayName = "Heavy Repeaters";
        category = "Statics";
        class Objects {
            MACRO_FORTIFY_ADD(MTI_HeavyRepeater,50,-1);
        };
    };

    class Arsenals: Default {
        scope = 1;
        displayName = "Arsenals";
        category = "Misc";
        class Objects {
            MACRO_FORTIFY_ADD(EGVAR(arsenal,trooper),100,1);
            MACRO_FORTIFY_ADD(EGVAR(arsenal,commando),100,1);
            MACRO_FORTIFY_ADD(EGVAR(arsenal,arc),100,1);
            MACRO_FORTIFY_ADD(EGVAR(arsenal,covertops),100,1);
            MACRO_FORTIFY_ADD(EGVAR(arsenal,pilot),100,1);
            MACRO_FORTIFY_ADD(EGVAR(arsenal,fieldsupport),100,1);
            MACRO_FORTIFY_ADD(EGVAR(arsenal,command),100,1);
        };
    };
*/
};
