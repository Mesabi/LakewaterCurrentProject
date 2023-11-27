extends Control

@onready var weaponName = $Weapon/WeaponName
var weaponNameText = "None Selected"

@onready var currentAmmo = $Weapon/CurrentAmmo
var currentAmmoText = 00

@onready var currentReload = $Weapon/CurrentReload
var currentReloadText = 00

@onready var currentHealth = $Status/CurrentHealth
var currentHealthText = 00

func _ready():
	pass # Replace with function body.

func setUpSelf(ammo, reloads, nameW, health):
	currentAmmoText = ammo
	currentReloadText = reloads
	weaponNameText = nameW
	currentHealthText = health
	doUIUpdate()




func doUIUpdate():
	weaponName.text = String(weaponNameText)
	currentAmmo.text = String(currentAmmoText)
	currentReload.text = String(currentReloadText)
	currentHealth.text = String(currentHealthText)
	pass
	
func updateCurrentAmmoText(amt):
	currentAmmoText = amt

func updateCurrentReloadText(amt):
	currentReloadText = amt

func updateWeaponName(thisName):
	weaponNameText = thisName

func updateHealthText(thisAmt):
	currentHealthText = thisAmt

