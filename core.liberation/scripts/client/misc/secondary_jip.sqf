waitUntil {	sleep 1; time > 20 };

if ( isNil "GRLIB_secondary_in_progress" ) exitWith {};
if ( GRLIB_secondary_in_progress < 0 ) exitWith {};

if ( GRLIB_secondary_in_progress == 0 ) then {
	[ 2 ] call remote_call_intel;
};

if ( GRLIB_secondary_in_progress == 2 ) then {
	[ 6 ] call remote_call_intel;
};
