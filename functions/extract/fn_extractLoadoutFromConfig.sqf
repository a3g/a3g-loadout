#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_configPath"];

GVAR(usedConfigs) pushBack _configPath;

private _checkWeapon = {
   params ["_type"];

   if (((_type call BIS_fnc_itemType)select 0) == "Weapon") exitWith {true};
   false
};
{
    private _value = [_configPath >> _x, "array", false] call CBA_fnc_getConfigEntry;
    if (_value isEqualTo false) then {
        _value = [_configPath >> _x, "text", false] call CBA_fnc_getConfigEntry;
    };
    if (!(_value isEqualTo false)) then {
        // "Unsupported loadout value",  // TODO use the TITLE variant added 2016-10
        ERROR_2("Config property %1 is not supported anymore, was found in %2. Please see README", _x, _configPath);
    };
} forEach [
    "magazines",
    "items",
    "addMagazines",
    "addItems",
    "weapons",
    "linkedItems",
    "primaryWeaponAttachments",
    "secondaryWeaponAttachments",
    "handgunWeaponAttachments"
];

private _configValues = [] call CBA_fnc_hashCreate;

{
    private _value = [_configPath >> _x, "text", false] call  CBA_fnc_getConfigEntry;
    if (!(_value isEqualTo false)) then {
        [_configValues, _x, _value] call CBA_fnc_hashSet;
    };
    _value = [_configPath >> _x, "array", false] call CBA_fnc_getConfigEntry;
    if (!(_value isEqualTo false)) then {
        [_configValues, _x, (selectRandom _value)] call CBA_fnc_hashSet;
    };
} forEach [
    "uniform",
    "vest",
    "backpack",
    "primaryWeapon",
    "primaryWeaponMagazine",
    "primaryWeaponMuzzle",
    "primaryWeaponOptics",
    "primaryWeaponPointer",
    "primaryWeaponUnderbarrel",
    "primaryWeaponUnderbarrelMagazine",
    "secondaryWeapon",
    "secondaryWeaponMagazine",
    "secondaryWeaponMuzzle",
    "secondaryWeaponOptics",
    "secondaryWeaponPointer",
    "secondaryWeaponUnderbarrel",
    "secondaryWeaponUnderbarrelMagazine",
    "handgunWeapon",
    "handgunWeaponMagazine",
    "handgunWeaponMuzzle",
    "handgunWeaponOptics",
    "handgunWeaponPointer",
    "handgunWeaponUnderbarrel",
    "handgunWeaponUnderbarrelMagazine",
    "headgear",
    "goggles",
    "nvgoggles",
    "binoculars",
    "map",
    "gps",
    "compass",
    "watch",
    "radio"
];

{
    private _value = [_configPath >> _x, "array", false] call  CBA_fnc_getConfigEntry;
    if (!(_value isEqualTo false)) then {
        [_configValues, _x, _value] call CBA_fnc_hashSet;
    };
} forEach [
    "addItemsToUniform",
    "addItemsToVest"
];

private _value = [_configPath >> "addItemsToBackpack", "array", false] call  CBA_fnc_getConfigEntry;
if (!(_value isEqualTo false)) then {
    {
      private _check = [_x] call _checkWeapon;
      if (_check) then {
         private _muzzle = [_configPath >> _x >> "muzzle", "text", ""] call  CBA_fnc_getConfigEntry;
         private _pointer = [_configPath >> _x >> "pointer", "text", ""] call  CBA_fnc_getConfigEntry;
         private _scope = [_configPath >> _x >> "optics", "text", ""] call  CBA_fnc_getConfigEntry;
         private _magazine = [_configPath >> _x >> "magazine", "text", ""] call  CBA_fnc_getConfigEntry;
         private _underBarrelMagazine = [_configPath >> _x >> "underBarrelMagazine", "text", ""] call  CBA_fnc_getConfigEntry;
         private _underBarrel = [_configPath >> _x >> "underBarrel", "text", ""] call  CBA_fnc_getConfigEntry;
         _value set [_forEachIndex, [_x, _muzzle, _pointer, _scope, _magazine, _underBarrelMagazine, _underBarrel]];
      }else{
         private _check = true;
         private _type = _x;

         {
            if (isClass (configFile >> _x >> _type)) exitWith {_check = false;};
         }forEach ["CfgWeapons", "CfgAmmo", "CfgVehicles", "CfgMagazines", "CfgItems"];

         if (_check) then {
            _check  = [_type] call _checkWeapon;
            private _weapon = [_configPath >> _x >> "weapon", "text", ""] call  CBA_fnc_getConfigEntry;

            if (!(_weapon isEqualTo "") && _check) then {
               private _muzzle = [_configPath >> _type >> "muzzle", "text", ""] call  CBA_fnc_getConfigEntry;
               private _pointer = [_configPath >> _type >> "pointer", "text", ""] call  CBA_fnc_getConfigEntry;
               private _scope = [_configPath >> _type >> "optics", "text", ""] call  CBA_fnc_getConfigEntry;
               private _magazine = [_configPath >> _type >> "magazine", "text", ""] call  CBA_fnc_getConfigEntry;
               private _underBarrelMagazine = [_configPath >> _type >> "underBarrelMagazine", "text", ""] call  CBA_fnc_getConfigEntry;
               private _underBarrel = [_configPath >> _type >> "underBarrel", "text", ""] call  CBA_fnc_getConfigEntry;
               _value set [_forEachIndex, [_weapon, _muzzle, _pointer, _scope, _magazine, _underBarrelMagazine, _underBarrel]];
            };
         };
      };

    } forEach _value;
    [_configValues, "addItemsToBackpack", _value] call CBA_fnc_hashSet;
};

_configValues
