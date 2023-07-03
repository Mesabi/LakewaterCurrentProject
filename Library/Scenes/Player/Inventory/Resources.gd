extends Node2D
#plan to rename this file Ammo and use only for ammunition


# Declare private variables
var _gatling_ammo: int = 0#
var _beam_ammo: int = 0
var _wave_ammo: int = 0
var _homing_ammo: int = 0
var _missile_ammo: int = 0
#plan to remove keys from this, and place elsewhere.
var _has_hacking: bool = false
var _has_key: bool = false




var _gatlingReloads: int = 0
var _BeamReloads: int = 0
var _WaveReloads: int = 0
var _HomingReloads: int = 0



func setUpSelf():
	#set_gatling_ammo(100)
	#set_gatlingReloads(2)
	#plan to set this up as an array?
	pass




func set_this_amt(current_weapon, amt):
	#used to reset a ammo amt when it is switched. 
	amt = int(amt)
	match current_weapon:
		"gatling":
			set_gatling_ammo(amt)
		"beam":
		# code for beam weapon
			set_beam_ammo(amt)
		"homing":
		# code for homing weapon
			set_homing_ammo(amt)
		"wave":
			set_wave_ammo(amt)
		# code for wave weapon
		_:
		# default code if none of the above cases match
			print("Invalid weapon type")

func set_this_reload(current_weapon, amt):
	amt = int(amt)
	#used to reset a ammo amt when it is switched. 
	match current_weapon:
		"gatling":
			set_gatlingReloads(amt)
		"beam":
		# code for beam weapon
			set_BeamReloads(amt)
		"homing":
		# code for homing weapon
			set_homingReloads(amt)
		"wave":
			set_WaveReloads(amt)
		# code for wave weapon
		_:
		# default code if none of the above cases match
			print("Invalid weapon type")

func reload_this(current_weapon):
	#used to reset a ammo amt when it is switched. 
	match current_weapon:
		"gatling":
			if(get_gatlingReloads() > 0):
				set_gatlingReloads(get_gatlingReloads()-1)
				set_gatling_ammo(100)
				return true
			else:
				return false
		"beam":
			if(get_WaveReloads() > 0):
				set_WaveReloads(get_WaveReloads()-1)
				set_wave_ammo(100)
				return true
			else:
				return false
		"homing":
			if(get_BeamReloads() > 0):
				set_BeamReloads(get_BeamReloads()-1)
				set_beam_ammo(100)
				return true
			else:
				return false
		"wave":
			if(get_HomingReloads() > 0):
				set_homingReloads(get_HomingReloads()-1)
				set_homing_ammo(100)
				return true
			else:
				return false
		_:
		# default code if none of the above cases match
			return false

func get_gatlingReloads() -> int:
	return _gatlingReloads

func set_gatlingReloads(value: int) -> void:
	_gatlingReloads = value

func get_BeamReloads() -> int:
	return _BeamReloads

func set_BeamReloads(value: int) -> void:
	_BeamReloads = value

func get_WaveReloads() -> int:
	return _WaveReloads

func set_WaveReloads(value: int) -> void:
	_WaveReloads = value

func get_HomingReloads() -> int:
	return _HomingReloads

func set_homingReloads(value: int) -> void:
	_HomingReloads = value

# Declare getters and setters for public access to private variables
func set_gatling_ammo(value: int) -> void:
	_gatling_ammo = value

func get_gatling_ammo() -> int:
	return _gatling_ammo

func set_beam_ammo(value: int) -> void:
	_beam_ammo = value

func get_beam_ammo() -> int:
	return _beam_ammo

func set_wave_ammo(value: int) -> void:
	_wave_ammo = value

func get_wave_ammo() -> int:
	return _wave_ammo

func set_homing_ammo(value: int) -> void:
	_homing_ammo = value

func get_homing_ammo() -> int:
	return _homing_ammo

func set_missile_ammo(value: int) -> void:
	_missile_ammo = value

func get_missile_ammo() -> int:
	return _missile_ammo

func set_has_hacking(value: bool) -> void:
	_has_hacking = value

func get_has_hacking() -> bool:
	return _has_hacking

func set_has_key(value: bool) -> void:
	_has_key = value

func get_has_key() -> bool:
	return _has_key

func getThisReload(thisReload):
	match thisReload:
		"gatling":
			return get_gatlingReloads()
		"beam":
		# code for beam weapon
			return get_BeamReloads()
		"homing":
		# code for homing weapon
			return get_HomingReloads()
		"wave":
			return get_WaveReloads()
		_:
		# default code if none of the above cases match
			print("Invalid weapon type")
	pass

func getThisAmmo(thisReload):
	match thisReload:
		"gatling":
			return get_gatling_ammo()
		"beam":
		# code for beam weapon
			return get_beam_ammo()
		"homing":
		# code for homing weapon
			return get_homing_ammo()
		"wave":
			return get_wave_ammo()
		_:
		# default code if none of the above cases match
			print("Invalid weapon type")
	pass

func returnAllValues():
	var ammo = [getThisAmmo("gatling"), getThisAmmo("beam"), getThisAmmo("wave"), getThisAmmo("homing")]
	var reload = [getThisReload("gatling"), getThisReload("beam"), getThisReload("wave"), getThisReload("homing")]
	var combine = ammo + reload
	return combine
	
