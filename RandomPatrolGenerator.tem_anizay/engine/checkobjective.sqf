#include "..\objectgenerator\vehicleManagement.sqf"

_objectivestoTest = _this select 0;
_objectivesDestinationArea = _this select 1;

// Obj management
obj_list_items = [];
respawnsettings = ["Respawn", 1] call BIS_fnc_getparamValue;
campaignmode = "Campaignmode" call BIS_fnc_getparamValue;

// Define current test
current_obj = objNull;

missionComplete = false;
RTBComplete = false;
isRTBMissionGenerated = false;
numberOfCompletedobj = 0;
numberOfObjectives = count _objectivestoTest;

independantTrigger = createTrigger ["EmptyDetector", getPos _objectivesDestinationArea];
// create a trigger area created at object with variable name my_object
independantTrigger settriggerArea [60, 60, 0, false];
// trigger area with a radius of 100m.

waitUntil {
    !isnil "missionGenerated"
};
waitUntil {
    missionGenerated
};

bluforTrigger = createTrigger ["EmptyDetector", initBlueforLocation];
// create a trigger area created at object with variable name my_object
bluforTrigger settriggerArea [100, 100, 0, false];
// trigger area with a radius of 100m.
objectReturnedtoCity = [];

if (respawnsettings == 1) then {
    [] execVM "engine\respawnsetup.sqf";
};

while {
    sleep 10;
    !RTBComplete
} do {
    _completedobjectives = missionnamespace getVariable ["completedobjectives", []];
    _missionObjectives = missionnamespace getVariable ["MissionObjectives", []];
    _missionUncompletedobjectives = missionnamespace getVariable ["missionUncompletedobjectives", _missionObjectives];
    missionnamespace setVariable ["missionUncompletedobjectives", _missionUncompletedobjectives, true];
    diag_log format ["Loop to test objective : %1", _objectivestoTest];
    
    {
        obj_list_items pushBack (_x select 0);
    } forEach _missionUncompletedobjectives;
    
    objectReturnedtoCity = obj_list_items inAreaArray independantTrigger;
    // vehicles (all vehicles) inAreaArray (Returns list of Objects or positions that are in the area _independantTrigger.)
    objectReturnedtoFOB = obj_list_items inAreaArray bluforTrigger;
    {
        current_obj = _x;
        diag_log format ["Currently test objective : %1", current_obj];
        
        switch (current_obj select 1) do
        {
            case "steal":
            {
                if (current_obj select 0 in objectReturnedtoCity || current_obj select 0 in objectReturnedtoFOB) then {
                    diag_log format ["Objective %1 completed !", current_obj select 0 ];
                    obj_list_items = obj_list_items - [current_obj select 0];
                    _missionUncompletedobjectives = _missionUncompletedobjectives - [current_obj];
                    missionnamespace setVariable ["missionUncompletedobjectives", _missionUncompletedobjectives, true];
                    _completedobjectives pushBack current_obj;
                    missionnamespace setVariable ["completedobjectives", _completedobjectives, true];
                    [[format ["L'objectif %1 est terminé", gettext (configFile >> "cfgvehicles" >> typeOf (current_obj select 0) >> "displayname")], independent], 'engine\doGenerateMessage.sqf'] remoteExec ['BIS_fnc_execVM', 0];
                    // Manage player's feedback
                    if ("Realismmode" call BIS_fnc_getparamValue == 1) then {
                        [] call doincrementvehiclespawncounter;
                        [current_obj] execVM 'engine\completeObjective.sqf';
                    };
                    if (respawnsettings == 1) then {
                        [[], "engine\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
                    };
                };
            };
            case "supply":
            {
                if (current_obj select 0 in objectReturnedtoCity || current_obj select 0 in objectReturnedtoFOB) then {
                    diag_log format ["Objective %1 completed !", current_obj select 0 ];
                    obj_list_items = obj_list_items - [current_obj select 0];
                    _missionUncompletedobjectives = _missionUncompletedobjectives - [current_obj];
                    missionnamespace setVariable ["missionUncompletedobjectives", _missionUncompletedobjectives, true];
                    _completedobjectives pushBack current_obj;
                    missionnamespace setVariable ["completedobjectives", _completedobjectives, true];
                    [[format ["L'objectif %1 est terminé", gettext (configFile >> "cfgvehicles" >> typeOf (current_obj select 0) >> "displayname")], independent], 'engine\doGenerateMessage.sqf'] remoteExec ['BIS_fnc_execVM', 0];
                    // Manage player's feedback
                    if ("Realismmode" call BIS_fnc_getparamValue == 1) then {
                        [] call doincrementvehiclespawncounter;
                        [current_obj] execVM 'engine\completeObjective.sqf';
                    };
                    if (respawnsettings == 1) then {
                        [[], "engine\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
                    };
                };
            };
            case "ammo":
            {
                if (current_obj select 0 in objectReturnedtoCity || current_obj select 0 in objectReturnedtoFOB) then {
                    diag_log format ["Objective %1 completed !", current_obj select 0 ];
                    obj_list_items = obj_list_items - [current_obj select 0];
                    _missionUncompletedobjectives = _missionUncompletedobjectives - [current_obj];
                    missionnamespace setVariable ["missionUncompletedobjectives", _missionUncompletedobjectives, true];
                    _completedobjectives pushBack current_obj;
                    missionnamespace setVariable ["completedobjectives", _completedobjectives, true];
                    [[format ["L'objectif %1 est terminé", gettext (configFile >> "cfgvehicles" >> typeOf (current_obj select 0) >> "displayname")], independent], 'engine\doGenerateMessage.sqf'] remoteExec ['BIS_fnc_execVM', 0];
                    // Manage player's feedback
                    if ("Realismmode" call BIS_fnc_getparamValue == 1) then {
                        [] call doincrementvehiclespawncounter;
                        [current_obj] execVM 'engine\completeObjective.sqf';
                    };
                    if (respawnsettings == 1) then {
                        [[], "engine\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
                    };
                };
            };
            case "hvt":
            {
                if (!alive (current_obj select 0)) then {
                    diag_log format ["Objective %1 completed !", current_obj select 0 ];
                    obj_list_items = obj_list_items - [current_obj select 0];
                    _missionUncompletedobjectives = _missionUncompletedobjectives - [current_obj];
                    missionnamespace setVariable ["missionUncompletedobjectives", _missionUncompletedobjectives, true];
                    _completedobjectives pushBack current_obj;
                    missionnamespace setVariable ["completedobjectives", _completedobjectives, true];
                    [[format ["L'objectif %1 est terminé", gettext (configFile >> "cfgvehicles" >> typeOf (current_obj select 0) >> "displayname")], independent], 'engine\doGenerateMessage.sqf'] remoteExec ['BIS_fnc_execVM', 0];
                    // Manage player's feedback
                    if ("Realismmode" call BIS_fnc_getparamValue == 1) then {
                        [] call doincrementvehiclespawncounter;
                        [current_obj] execVM 'engine\completeObjective.sqf';
                    };
                    if (respawnsettings == 1) then {
                        [[], "engine\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
                    };
                };
            };
            case "vip":
            {
                if (current_obj select 0 in objectReturnedtoCity || current_obj select 0 in objectReturnedtoFOB) then {
                    diag_log format ["Objective %1 completed !", current_obj select 0 ];
                    obj_list_items = obj_list_items - [current_obj select 0];
                    _missionUncompletedobjectives = _missionUncompletedobjectives - [current_obj];
                    missionnamespace setVariable ["missionUncompletedobjectives", _missionUncompletedobjectives, true];
                    _completedobjectives pushBack current_obj;
                    missionnamespace setVariable ["completedobjectives", _completedobjectives, true];
                    // Manage player's feedback
                    if ("Realismmode" call BIS_fnc_getparamValue == 1) then {
                        [] call doincrementvehiclespawncounter;
                        [current_obj] execVM 'engine\completeObjective.sqf';
                    };
                    [[format ["L'objectif %1 est terminé", gettext (configFile >> "cfgvehicles" >> typeOf (current_obj select 0) >> "displayname")], independent], 'engine\doGenerateMessage.sqf'] remoteExec ['BIS_fnc_execVM', 0];
                    if (respawnsettings == 1) then {
                        [[], "engine\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
                    };
                };
            };
            case "convoy":
            {
                hint "default"
            };
            default {
                hint "default"
            };
        };
    } forEach _missionUncompletedobjectives;
    missionComplete = count _completedobjectives + 1 >= count _missionObjectives;
    
    // Check if mission is complete
    if (missionComplete && campaignmode == 0) then {
        // Generate RTB mission
        if (!isRTBMissionGenerated) then {
            [true, "taskRTB", ["Return to your initial base", "RTB", ""], objNull, 1, 3, true] call BIS_fnc_taskCreate;
            isRTBMissionGenerated = true;
        };
        
        nbBlueplayer = {
            alive _x && side _x == blufor
        } count allplayers;
        nbindplayer = {
            alive _x && side _x == independent
        } count allplayers;
        nbBlueplayerBack = count ((allplayers select {
            alive _x && side _x == blufor
        } ) inAreaArray bluforTrigger);
        // vehicles (all vehicles) inAreaArray (Returns list of Objects or positions that are in the area _independantTrigger.)
        nbindplayerBack = count ((allplayers select {
            alive _x && side _x == independent
        } ) inAreaArray independantTrigger);
        if (nbBlueplayer == nbBlueplayerBack && nbindplayer == nbindplayerBack) then {
            ["taskRTB", "SUCCEEDED"] call BIS_fnc_tasksetState;
            RTBComplete = true;
        };
    };
};

diag_log format ["All objectives completed !"];
if (isMultiplayer) then {
    'OBJ_OK' call BIS_fnc_endMissionServer;
} else {
    'OBJ_OK' call BIS_fnc_endMission;
};