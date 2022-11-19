#include ".\searchLocation.sqf"
/* Credits :
* @tova from the bohemia forums
* The Arma community.
* original Bohemia forums post: https:// forums.bohemia.net/forums/topic/226608-simple-convoy-script-release/
* Used with waypoints
* We can use the addWaypoint function :
* Adds (or inserts when index is given) a new waypoint to a group.
* The waypoint is placed randomly within a circle with the given center and radius.
* The function returns a waypoint with format [group, index].
* Syntax: groupname addWaypoint [center, radius, index, name]
* params:
* - groupname: group
* - center: Array format positionAGL (positionASL if radius is negative!) or Object
* - radius: Number - random waypoint placement within radius from center
* 					since Arma 3 v1.90, -1 may be used for exact waypoint placement
* - index (optional): Number - can be used to insert a waypoint in between existing waypoints
* - name (optional): string - waypointName
* example: _wp = _grp addWaypoint [position player, 0];
* Change some part of the script to take markers instead of waypoint
* (so if we want we can switch easily between this and the norrin&deva's script)
* Maybe use forceFollowRoad function in the script ?
* Add parameter to set behaviour (with default set to AWARE)
*/

/*
* The two main usages for this script are:

1) player team attacks convoy:
player Attack Convoy, if the convoy wins by killing attackers, then player objective or mission fails,
and it doesn't really matter if any convoy vehicles get stuck.
2) player team defends/escorts convoy:
player Defend/Escort Convoy, if lead vehicles are disabled and blocking convoy,
then it could be up to the player to clear those vehicles by pushing them with a remaining vehicle,
or taking command of convoy, and ordering them to move to other positions to go around.
It would be up to the mission maker to allow player to handle a blocked convoy situation.
*/

/*
* Prior rule of thumb for convoy:
* - keep it simple: don't stack plenty of commands by vehicles.
* - group them and choose the column formation. At the end, you'll have to verify the good order in preview.
* Sometimes it's surprising: some vehicles give way to another one then "shuffle" order...
* So, group them one by one from 2nd to last, on leader. This is also possible in scripted way,
* as you join the group one vehicle by one but mind for the relative positions!
* - for the group, set safe mode, don't mess with other parameters, but driver (each vehicles) disableAI "autocombat";
(gunners can fire)
* - limit the speed of the leader: if (isServer) then {
    yourleadervehicleHere limitSpeed 50
};
// and leader only!
* - adjust the distance between vehicle: if (isServer) then {
    theSecondvehicleHere setConvoySeparation 20
};
// same distance for each following vehicle.
* - waypoints "move" as usual. not too many! don't multiplicate path calculation. intermediate wpts are useless most of the time.
*/

/* documentation:
* Put the script code in an sqf file, trigger, init field or whatever you fancy, then call it with :
*
* convoyScript = [convoygroup] spawn toV_fnc_SimpleConvoy;
* Optional parameters are also available :

* convoyScript = [convoygroup, convoyspeed, convoySeparation, pushThrough] spawn toV_fnc_SimpleConvoy;
* with :
*
* convoygroup : the group you want to move as a convoy
* convoyspeed : maximum speed of the convoy in km/h (default 50 km/h)
* convoySeparation : distance between each vehicle of the convoy (default 50m)
* pushThrough : true/false, force the AI to push through contact, only returning fire on the move (default true)
*
*
* The script doesn't exit himself, so once you reach your final waypoint, you'll have to end it with :
*
* terminate convoyScript;
* {
    (vehicle _x) limitSpeed 5000;
    (vehicle _x) setUnloadInCombat [true, false]
} forEach (units convoygroup);
* convoygroup enableAttack true;
*/

/*
* Known limitations :

* - Due to how setConvoySeparation works, the convoy will stop on tight turns,
* vehicles crossing one at a time. Rear vehicles will then often cut the corner
* to catch up faster if possible (doFollow behavior).
* - Also as a side note, I have noticed that if it is the lead vehicle that gets killed, the convoy always stalls
* (stops moving toward the waypoint, with n°2 vehicle not taking lead vehicle's role), maybe you have an idea for a fix ?
* - Limitation of AI driving. if drivers (not the leader vehicles) get killed and their trucks are blocking the street then
* because of Arma 3 AI path-finding limitations, the other vehicles can't calculate a path to continue past them, and gets stuck.
* disable blocked vehicles by setting engine damage to 1. player would hopefully be unaware this "cheat" occurred, and mission has
* a natural looking outcome (ai abandons damaged vehicles). This might be a good option for player Attacks Convoy mission.
* - Behavior of the convoy when "pushThrough" parameter is disabled isn't very satisfying :
* passengers in cargo slots will disembark (but keep formation) to engage, armed vehicles
* will leave convoy formation to engage, some unarmed vehicles will just stop while others
* will keep pushing on etc. The convoy will eventually recover after the contact is destroyed
* and the leader calls "Area Clear" (as in they will mount up again and resume convoy route).
* That however might take up to 20 minutes, as the convoy and dismounts are usually spread
* over a couple km after the fight.
*/

/*comments in code are for an exit condition in order that the exit does not need to be called manually.
* condition = {
    some code
};
[convoygroup, convoyspeed, convoySeparation, pushThrough, condition] spawn toV_fnc_SimpleConvoy;
*/

doGenerateConvoy =
{
    params ["_side", "_convoyPosition"];
    
    _convoyGroup=createGroup [_side, true];
    
    _vehiculeNumber = 3 min (difficultyParameter + 1);
    _lightVehiculeNumber = 2 min (difficultyParameter + 1);
    _heavyVehiculeNumber = 1 min (difficultyParameter / 4);
    
    // todo: something better for spawning vehicle (like one behind the other)
    _vehiculePosition = [_convoyPosition, 20, 40, _vehiculeNumber] call getListOfPositionsAroundTarget;
    _lightVehiculePosition = [_convoyPosition, 20, 40, _lightVehiculeNumber] call getListOfPositionsAroundTarget;
    _heavyVehiculePosition = [_convoyPosition, 20, 40, _heavyVehiculeNumber] call getListOfPositionsAroundTarget;
    diag_log format ["vehicule pos ! : %1", _vehiculePosition];
    diag_log format ["light vehicule pos ! : %1", _lightVehiculePosition];
    diag_log format ["vehicule pos ! : %1", _heavyVehiculePosition];
    
    for "_i" from 0 to _heavyVehiculeNumber do
    {
        _newVeh= selectRandom baseEnemyHeavyArmoredVehicleGroup createVehicle (_heavyVehiculePosition select _i);
        createVehicleCrew _newVeh;
        [_newVeh] joinSilent _convoyGroup;
        sleep 0.5;
    };
    
    for "_i" from 0 to _lightVehiculeNumber do
    {
        _newVeh= selectRandom baseEnemyLightArmoredVehicleGroup createVehicle (_lightVehiculePosition select _i);
        createVehicleCrew _newVeh;
        [_newVeh] joinSilent _convoyGroup;
        sleep 0.5;
    };
    
    for "_i" from 0 to _vehiculeNumber do
    {
        _newVeh= selectRandom baseEnemyVehicleGroup createVehicle (_vehiculePosition select _i);
        createVehicleCrew _newVeh;
        [_newVeh] joinSilent _convoyGroup;
        sleep 0.5;
    };
    
    _convoyGroup;
};

TOV_fnc_SimpleConvoy =
{
    params ["_convoyGroup", ["_convoySpeed", 50], ["_convoySeparation", 50], ["_pushThrough", true]/*, ["_condition", {
        false
    }]*/];
    
    /* Improvement:
    * Basically the working principle of my script isn't to "enforce a convoy behaviour" but rather to "recover" vanilla COLUMN formation when it detects a vehicle is stuck.
    * Once it detects the group is in COMBAT, and if pushThrough is false that "recovery command" isn't run, in practice making the script inactive.
    * Terminating the script properly doesn't changes behaviour in combat.
    * Using a neartargets to detect end of engagements faster, and restart the script isn't enough, as the units will not mount back in vehicles.
    * I should add an orderGetIn to make them mount back and crack on.
    */
    if (_pushThrough) then {
        _convoyGroup enableAttack !(_pushThrough);
        {
            (vehicle _x) setUnloadInCombat [false, false];
        } forEach (units _convoyGroup);
    };
    
    _convoyGroup setFormation "COLUMN";
    // _convoyGroup setBehaviour "SAFE";
    
    {
        (vehicle _x) limitSpeed _convoySpeed*1.15;
        (vehicle _x) setConvoySeparation _convoySeparation;
    } forEach (units _convoyGroup);
    
    (vehicle leader _convoyGroup) limitSpeed _convoySpeed;
    
    while {
        sleep 5;
        !isNull _convoyGroup /*&& !(call _condition)*/
    } do {
        {
            if ((speed vehicle _x < 5) && (_pushThrough || (behaviour _x != "COMBAT"))) then {
                (vehicle _x) doFollow (leader _convoyGroup);
            };
        } forEach (units _convoyGroup)-(crew (vehicle (leader _convoyGroup)))-allplayers;
        
        {
            (vehicle _x) setConvoySeparation _convoySeparation;
            /* Keep drivers in "careless" behavior
            * This way, the drivers stay careless and follows the roads each time it's possible. The other crew can engage enemies.
            */
            // if (driver vehicle _x == _x && !isNull vehicle _x) then {
            //    _x setCombatbehaviour "CARELESS";
            //    driver vehicle _x disableAI "autocombat";
            // };
        } forEach (units _convoyGroup);
        
        // if (call _condition) exitWith {};
    };
    
    // Exiting:
    /*
    {
        (vehicle _x) limitSpeed 5000;
        (vehicle _x) setUnloadInCombat [true, false];
    } forEach (units _convoyGroup);
    
    _convoyGroup enableAttack true;
    
    terminate _thisScript;
    */
};