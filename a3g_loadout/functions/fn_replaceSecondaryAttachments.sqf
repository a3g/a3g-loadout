// Get config entry
_configPath = _this select 0;

{ player addSecondaryWeaponItem _x; } forEach getArray (_configPath);