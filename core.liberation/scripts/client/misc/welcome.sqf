/*
 Say hello, and set Rank/Insigna
*/
waitUntil {sleep 1;GRLIB_player_spawned};

while {	(player getVariable "GRLIB_score_set" == 0) } do {
	_msg= "... Loading Player Data ...";
    [_msg, 0, 0, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
	uIsleep 2;
	_msg= "... Please Wait ...";
    [_msg, 0, 0, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
	uIsleep 2;
};

// Load Loadout
if (! isNil "GRLIB_respawn_loadout" && isNil "GRLIB_loadout_overide") then {
	GRLIB_backup_loadout = [player] call F_getLoadout;
	player setVariable ["GREUH_stuff_price", ([player] call F_loadoutPrice)];
	[player, GRLIB_respawn_loadout] call F_setLoadout;
	[player] call F_payLoadout;
};

private _score = score player;
private _rank = [player] call set_rank;
private _ammo_collected = player getVariable ["GREUH_ammo_count",0];

// notice
if (_score == 0) then {	_dialog = createDialog "liberation_notice" };

private _msg = format ["Welcome <t color='#00008f'>%1</t> !<br/><br/>
Your Rank : <t color='#000080'>%2</t><br/>
Your Score : <t color='#008000'>%3</t><br/>
Your Credit : <t color='#800000'>%4</t>", name player, _rank, _score, _ammo_collected];
[_msg, 0, 0, 10, 0, 0, 90] spawn BIS_fnc_dynamicText;

// HCI Command IA
hcRemoveAllGroups player;
if ( player == [] call F_getCommander ) then {

	private _myveh = [vehicles, {
		(_x distance lhd) >= 1000 &&
		[player, _x] call is_owner &&
		_x getVariable ["GRLIB_vehicle_manned", false] &&
		count (crew _x) > 0
	}] call BIS_fnc_conditionalSelect;

	{ player hcSetGroup [group _x] } foreach _myveh;
};
private _grp = player getVariable ["my_squad", nil];
if (!isNil "_grp") then { player hcSetGroup [_grp] };
{player hcSetGroup [group _x]} forEach ([vehicles, {(typeOf _x) in uavs && [player, _x] call is_owner}] call BIS_fnc_conditionalSelect);

// IA Recall
private _grp = group player;
private _squad = allUnits select {(_x getVariable ["PAR_Grp_ID","0"]) == format["Bros_%1",PAR_Grp_ID]};
{
	if ( !(_x in units _grp) ) then {
		if ( count (units _grp) < (GRLIB_squad_size + GRLIB_squad_size_bonus) ) then { [_x] joinSilent _grp};
		sleep 0.5;
	};
} forEach _squad;
