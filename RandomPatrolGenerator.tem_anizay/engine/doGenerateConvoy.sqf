/* Credits :
* @Tova from the bohemia forums
* The Arma community.
* Used with waypoints
* We can use the addWaypoint function :
* Adds (or inserts when index is given) a new waypoint to a group. 
* The waypoint is placed randomly within a circle with the given center and radius. 
* The function returns a waypoint with format [group, index].
* Syntax: groupName addWaypoint [center, radius, index, name]
* params: 
* - groupName: Group
* - center: Array format PositionAGL (PositionASL if radius is negative!) or Object
* - radius: Number - random waypoint placement within radius from center
* 					Since Arma 3 v1.90, -1 may be used for exact waypoint placement
* - index (optional): Number - can be used to insert a waypoint in between existing waypoints
* - name (optional): String - waypointName
* example: _wp = _grp addWaypoint [position player, 0];
* Change some part of the script to take markers instead of waypoint 
* (so if we want we can switch easily between this and the norrin&deva's script)
* Maybe use forceFollowRoad function in the script ?
* Add Parameter to set behaviour (with default set to AWARE)
*/


/* Documentation:
* Put the script code in an sqf file, trigger, init field or whatever you fancy, then call it with :
*
* convoyScript = [convoyGroup] spawn TOV_fnc_SimpleConvoy;
* Optional parameters are also available :

* convoyScript = [convoyGroup, convoySpeed, convoySeparation, pushThrough] spawn TOV_fnc_SimpleConvoy;
* With :
*
* convoyGroup : the group you want to move as a convoy
* convoySpeed : Maximum speed of the convoy in km/h (default 50 km/h)
* convoySeparation : distance between each vehicle of the convoy (default 50m)
* pushThrough : true/false, force the AI to push through contact, only returning fire on the move (default true)
*
*
* The script doesn't exit himself, so once you reach your final waypoint, you'll have to end it with :
*
* terminate convoyScript;
* {(vehicle _x) limitSpeed 5000;(vehicle _x) setUnloadInCombat [true, false]} forEach (units convoyGroup);
* convoyGroup enableAttack true;
*/

/*
* Known limitations :

* - Due to how setConvoySeparation works, the convoy will stop on tight turns, 
* vehicles crossing one at a time. Rear vehicles will then often cut the corner 
* to catch up faster if possible (doFollow behavior).
* - Behavior of the convoy when "pushThrough" parameter is disabled isn't very satisfying : 
* passengers in cargo slots will disembark (but keep formation) to engage, armed vehicles 
* will leave convoy formation to engage, some unarmed vehicles will just stop while others 
* will keep pushing on etc. The convoy will eventually recover after the contact is destroyed 
* and the leader calls "Area Clear" (as in they will mount up again and resume convoy route). 
* That however might take up to 20 minutes, as the convoy and dismounts are usually spread
*  over a couple km after the fight.
*/


TOV_fnc_SimpleConvoy = { 
	params ["_convoyGroup",["_convoySpeed",50],["_convoySeparation",50],["_pushThrough", true]];
	if (_pushThrough) then {
		_convoyGroup enableAttack !(_pushThrough);
		{(vehicle _x) setUnloadInCombat [false, false];} forEach (units _convoyGroup);
	};
	_convoyGroup setFormation "COLUMN";
	{
    	(vehicle _x) limitSpeed _convoySpeed*1.15;
        (vehicle _x) setConvoySeparation _convoySeparation;
    } forEach (units _convoyGroup);
	(vehicle leader _convoyGroup) limitSpeed _convoySpeed;
	while {sleep 5; !isNull _convoyGroup} do {
		{
			if ((speed vehicle _x < 5) && (_pushThrough || (behaviour _x != "COMBAT"))) then {
				(vehicle _x) doFollow (leader _convoyGroup);
			};	
		} forEach (units _convoyGroup)-(crew (vehicle (leader _convoyGroup)))-allPlayers;
        {(vehicle _x) setConvoySeparation _convoySeparation;} forEach (units _convoyGroup);
	}; 
};