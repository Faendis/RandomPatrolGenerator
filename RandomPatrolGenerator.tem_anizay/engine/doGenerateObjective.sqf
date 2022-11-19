#include "..\objectgenerator\vehicleManagement.sqf"
#include ".\doGenerateConvoy.sqf"

generateObjective =
{
    params ["_avalaibleTypeOfObj", "_possibleObjectivePosition"];
    
    // init mission objective status
    _completedObjectives = missionnamespace getVariable ["completedoObjectives", []];
    _missionObjectives = missionnamespace getVariable ["MissionObjectives", []];
    _missionUncompletedObjectives = missionnamespace getVariable ["missionUncompletedObjectives", _missionObjectives];
    
    // Generate a new objective
    SupplyObjects = [];
    selectedobjectives = [];
    publicVariable "SupplyObjects";
    publicVariable "SelectedObjectives";
    
    // currentObjtype = selectRandom _avalaibletypeOfObj;
    currentObjtype = "convoy";
    currentRandomPos = [] call BIS_fnc_randomPos;
    switch (currentObjtype) do
    {
        case "supply":
        {
            currentObj = createvehicle [selectRandom avalaibleSupplyBox, currentRandomPos, [], 0, "NONE"];
        };
        case "ammo":
        {
            currentObj = createvehicle [selectRandom avalaibleammoBox, currentRandomPos, [], 0, "NONE"];
        };
        case "hvt":
        {
            currentObj = leader ([currentRandomPos, east, [selectRandom avalaibleHVT], [], [], [], [], [], random 360] call BIS_fnc_spawngroup);
        };
        case "vip":
        {
            currentObj = leader ([currentRandomPos, civilian, [selectRandom avalaibleVIP], [], [], [], [], [], random 360] call BIS_fnc_spawngroup);
            currentObj setVariable ["missionObjectiveCivilian", true, true];
        };
        case "steal":
        {
            currentObj = createvehicle [selectRandom avalaibleStealvehicle, currentRandomPos, [], 0, "NONE"];
        };
        case "clearArea":
        {
            // Add trigger to detect cleared area
            currentObj = createTrigger ["EmptyDetector", currentRandomPos];
            // create a trigger area created at object with variable name my_object
        };
        case "collectintel":
        {
            // Add intel action to the intel case
            currentObj = createvehicle [selectRandom avalaibleCollectintel, currentRandomPos, [], 0, "NONE"];
            currentObj setVariable ["missionObjectiveCivilian", true, true];
        };
        case "informant":
        {
            // Add dialog to the informant
            currentObj = leader ([currentRandomPos, civilian, [selectRandom avalaibleVIP], [], [], [], [], [], random 360] call BIS_fnc_spawngroup);
        };
        case "convoy":
        {
            currentObj = [east, currentRandomPos] call doGenerateConvoy;
        };
        default {
            hint "default"
        };
    };
    
    _currentObject = [currentObj, currentObjtype];
    _selectedObjectivePosition = selectRandom _possibleObjectivePosition;
    _possibleObjectivePosition = _possibleObjectiveposition - [_selectedObjectivePosition];
    
    diag_log format ["Objective generation started : %1 on position %2", _currentObject, _selectedObjectivePosition];
    
    // Generate mission environement
    _handlePOIGeneration = [EnemyWaveLevel_1, baseEnemyVehicleGroup, baseEnemyLightArmoredVehicleGroup, baseEnemyHeavyArmoredVehicleGroup, civilian_group, _selectedObjectivePosition, difficultyParameter] execVM 'enemyManagement\generatePOI.sqf';
    waitUntil {
        isNull _handlePOIGeneration
    };
    
    // Generate mission objectives
    [_currentObject, _selectedObjectivePosition] call generateObjectiveObject;
    _possibleObjectivePosition;
};

generateObjectiveObject =
{
    params ["_thisObjective", "_thisObjectivePosition"];
    
    // move Object objective and create marker
    if (count _thisObjective > 0) then {
        objectiveObject = _thisObjective select 0;
        objectiveType = _thisObjective select 1;
        _objectiveUniqueID = format ["%1%2", objectiveType, random 10000];
        _thisObjective pushBack _objectiveUniqueID;
        
        switch (objectiveType) do
        {
            case "supply":
            {
                (objectiveObject) setPos ([(getPos _thisObjectiveposition), 1, 25, 5, 0, 20, 0] call BIS_fnc_findSafePos);
                
                // Objective failed
                objectiveObject setVariable ["thisTask", _objectiveUniqueID, true];
                objectiveObject addEventHandler ["Killed", {
                    params ["_unit", "_killer", "_instigator", "_useEffects"];
                    // get task associated to the object
                    _thisTaskID = _unit getVariable "thisTask";
                    // Manage objective
                    _missionFailedObjectives = missionnamespace getVariable ["missionFailedObjectives", []];
                    _missionFailedObjectives = _missionFailedObjectives + [_thisTaskID];
                    // needs to be improved
                    missionnamespace setVariable ["missionFailedObjectives", _missionFailedObjectives, true];
                    // Manage task system
                    if ("RealismMode" call BIS_fnc_getparamValue == 1) then {
                        [_thisTaskID, "FAILED"] call BIS_fnc_tasksetState;
                    };
                }];
            };
            case "ammo":
            {
                (objectiveObject) setPos ([(getPos _thisObjectiveposition), 1, 25, 5, 0, 20, 0] call BIS_fnc_findSafePos);
                objectiveObject setVariable ["thisTask", _objectiveUniqueID, true];
                [_thisObjective] execVM 'engine\checkDeadvehicle.sqf';
            };
            case "hvt":
            {
                (objectiveObject) setPos (getPos _thisObjectiveposition);
                [objectiveObject, objectiveObject, 75, [], true] call lambs_wp_fnc_taskGarrison;
            };
            case "vip":
            {
                diag_log format ["VIP task setup ! : %1", objectiveObject];
                (objectiveObject) setPos (getPos _thisObjectivePosition);
                [objectiveObject, objectiveObject, 75, [], true] call lambs_wp_fnc_taskGarrison;
                
                // Use ACE function to set hancuffed
                if (isClass (configFile >> "CfgPatches" >> "ace_medical")) then {
                    [objectiveObject, true] call ACE_captives_fnc_setHandcuffed;
                };
                
                // Objective failed
                objectiveObject setVariable ["thisTask", _objectiveUniqueID, true];
                objectiveObject addEventHandler ["Killed", {
                    params ["_unit", "_killer", "_instigator", "_useEffects"];
                    // get task associated to the object
                    _thisTaskID = _unit getVariable "thisTask";
                    // Manage objective
                    _missionFailedObjectives = missionnamespace getVariable ["missionFailedObjectives", []];
                    _missionFailedObjectives = _missionFailedObjectives + [_thisTaskID];
                    // needs to be improved
                    missionnamespace setVariable ["missionFailedObjectives", _missionFailedObjectives, true];
                    // Manage task system
                    if ("RealismMode" call BIS_fnc_getparamValue == 1) then {
                        [_thisTaskID, "FAILED"] call BIS_fnc_tasksetState;
                    };
                }];
            };
            case "steal":
            {
                diag_log format ["Steal task setup ! : %1", objectiveObject];
                objectiveObject setPos ([(getPos _thisObjectiveposition), 1, 60, 7, 0, 20, 0] call BIS_fnc_findSafePos);
                
                // Objective failed
                objectiveObject setVariable ["thisTask", _objectiveUniqueID, true];
                objectiveObject addEventHandler ["Killed", {
                    params ["_unit", "_killer", "_instigator", "_useEffects"];
                    // get task associated to the object
                    _thisTaskID = _unit getVariable "thisTask";
                    // Manage objective
                    _missionFailedObjectives = missionnamespace getVariable ["missionFailedObjectives", []];
                    _missionFailedObjectives = _missionFailedObjectives + [_thisTaskID];
                    // needs to be improved
                    missionnamespace setVariable ["missionFailedObjectives", _missionFailedObjectives, true];
                    // Manage task system
                    if ("RealismMode" call BIS_fnc_getparamValue == 1) then {
                        [_thisTaskID, "FAILED"] call BIS_fnc_tasksetState;
                    };
                }];
            };
            case "clearArea":
            {
                // Add trigger to detect cleared area
                objectiveObject setPos (getPos _thisObjectiveposition);
                // create a trigger area created at object with variable name my_object
                objectiveObject settriggerArea [200, 200, 0, false];
                // trigger area with a radius of 200m.
                objectiveObject setVariable ["AssociatedTask", _thisObjective];
                [objectiveObject] execVM 'engine\checkClearArea.sqf';
            };
            case "collectintel":
            {
                // Add intel action to the intel case
                objectiveObject setPos ([(getPos _thisObjectiveposition), 1, 25, 5, 0, 20, 0] call BIS_fnc_findSafePos);
                [objectiveObject, ["Collect intel", {
                    params ["_object", "_caller", "_ID", "_thisObjective"];
                    // Manage Completed Objective
                    _completedObjectives = missionnamespace getVariable ["completedObjectives", []];
                    _completedObjectives pushBack _thisObjective;
                    missionnamespace setVariable ["completedObjectives", _completedObjectives, true];
                    // Manage Uncompletedobjective
                    _missionUncompletedObjectives = missionnamespace getVariable ["missionUncompletedObjectives", []];
                    _missionUncompletedObjectives = _missionUncompletedObjectives - [_thisObjective];
                    missionnamespace setVariable ["missionUncompletedObjectives", _missionUncompletedObjectives, true];
                    // Manage player's feedback
                    if ("RealismMode" call BIS_fnc_getparamValue == 1) then {
                        [] call doincrementvehiclespawncounter;
                        [_thisObjective] execVM 'engine\completeObjective.sqf';
                    };
                    // Manage respawn and delete object
                    deletevehicle _object;
                    if (["Respawn", 1] call BIS_fnc_getparamValue == 1) then {
                        [[], "engine\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
                    };
                }, _thisObjective, 1.5, true, true, "", "_target distance _this <3"]] remoteExec ["addAction", 0, true];
            };
            case "informant":
            {
                // Add dialog to the informant
                diag_log format ["VIP task setup ! : %1", objectiveObject];
                (objectiveObject) setPos (getPos _thisObjectiveposition);
                [objectiveObject, objectiveObject, 75, [], true] call lambs_wp_fnc_taskGarrison;
                
                // Objective completion
                [objectiveObject, ["Talk to the informant", {
                    params ["_object", "_caller", "_ID", "_thisObjective"];
                    // Manage Completed Objective
                    _completedObjectives = missionnamespace getVariable ["completedObjectives", []];
                    _completedObjectives pushBack _thisObjective;
                    missionnamespace setVariable ["completedObjectives", _completedObjectives, true];
                    // Manage Uncompletedobjective
                    _missionUncompletedObjectives = missionnamespace getVariable ["missionUncompletedObjectives", []];
                    _missionUncompletedObjectives = _missionUncompletedObjectives - [_thisObjective];
                    missionnamespace setVariable ["missionUncompletedObjectives", _missionUncompletedObjectives, true];
                    // Manage player's feedback
                    if ("RealismMode" call BIS_fnc_getparamValue == 1) then {
                        [] call doincrementvehiclespawncounter;
                        [_thisObjective] execVM 'engine\completeObjective.sqf';
                    };
                    // Manage respawn and remove actions from NPC
                    removeAllActions _object;
                    [_object] remoteExec ["removeAllActions", 0, true];
                    if (["Respawn", 1] call BIS_fnc_getparamValue == 1) then {
                        [[], "engine\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
                    };
                }, _thisObjective, 1.5, true, true, "", "_target distance _this <3"]] remoteExec ["addAction", 0, true];
                
                // Objective failed
                objectiveObject setVariable ["thisTask", _objectiveUniqueID, true];
                objectiveObject addEventHandler ["Killed", {
                    params ["_unit", "_killer", "_instigator", "_useEffects"];
                    // get task associated to the object
                    _thisTaskID = _unit getVariable "thisTask";
                    // Manage objective
                    _missionFailedObjectives = missionnamespace getVariable ["missionFailedObjectives", []];
                    _missionFailedObjectives = _missionFailedObjectives + [_thisTaskID];
                    // needs to be improved
                    missionnamespace setVariable ["missionFailedObjectives", _missionFailedObjectives, true];
                    // Manage task system
                    if ("RealismMode" call BIS_fnc_getparamValue == 1) then {
                        [_thisTaskID, "FAILED"] call BIS_fnc_tasksetState;
                    };
                }];
            };
            case "convoy":
            {
                diag_log format ["Convoy task setup ! : %1", objectiveObject];
                // todo: check if every vehicle in group are spawn in safe place
                // objectiveObject setPos ([(getPos _thisObjectiveposition), 1, 60, 7, 0, 20, 0] call BIS_fnc_findSafePos);
                _leader = leader objectiveObject;
                _pos = [getPos _thisObjectivePosition, 1, 60, 7, 0, 20, 0] call BIS_fnc_findSafePos;
                {
                    if (_x != _leader) then {
                        _relDis = _x distance _leader;
                        _relDir = [_leader, _x] call BIS_fnc_relativeDirto;
                        _x setPos ([_pos, _relDis, _relDir] call BIS_fnc_relPos);
                    };
                }forEach (units objectiveObject);
                _leader setPos _pos;
                _nearest = nearestLocations [_pos, ["NameVillage", "NameCity", "NameCityCapital"], 5000];
                _path= [ selectRandom _nearest, selectRandom _nearest, selectRandom _nearest];
                _wp = objectiveObject addWaypoint [_pos, 0];
                _wp setwaypointType "MOVE";
                {
                    _wp = objectiveObject addWaypoint [getPos _x, 0];
                    _wp setwaypointType "MOVE";
                } forEach _path;
                
                _wp = objectiveObject addWaypoint [_pos, 0];
                _wp setwaypointType "CYCLE";
                convoyScript = [objectiveObject] spawn toV_fnc_SimpleConvoy;
            };
            default {
                hint "default"
            };
        };
        currentMissionObjectives = missionnamespace getVariable ["MissionObjectives", []];
        currentMissionObjectives pushBack _thisObjective;
        missionnamespace setVariable ["MissionObjectives", currentMissionObjectives, true];
        diag_log format ["MissionObjectives setup ! : %1", currentMissionObjectives];
    };
};