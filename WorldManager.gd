extends Node2D

var save
onready var resources = $Resources
var state
onready var player = $Player
onready var health = $Player_Health
onready var UI = $CanvasLayer/test_ui
#Player/Camera2D/test_ui

var weapons_free = false


#currently, weapon ammo exists out of a "pool" here.
#when any reload, weapon change, etc. happens, we update the main resources with this amt
#and switch it to the main amount.
var current_weapon = "gatling"
var currentAmmo = 00
var currentReloads  = 00


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.



func _process(delta):
	getInput()

func doStartUpTasks():
	resources.setUpSelf()
	UI.setUpSelf(currentAmmo, currentReloads, current_weapon, health.points)
	updateResourcePoolSelf()
	updateUI()


func getInput():
	#if(Input.is_action_just_pressed("Pause")):
	#	pass
	if(Input.is_action_pressed("TEST")):
		#print(get_tree().get_root().get_node("Main").get_child(0).get_node("WorldManager").get_node("Player").global_position)
		print(resources.returnAllValues())
		#UI.currentHealth.text = "Asdf"
		pass
		#print(player.velocity)
	
	if(Input.is_action_just_pressed("click")):
		#print("mouse")
		#print(get_global_mouse_position())
		#print("player")
		#print(player.global_position)
		#print(get_global_mouse_position().distance_to(player.global_position))
		pass
	
	if(Input.is_action_just_pressed("switch")):#change to "switch weapon" also add hot keys.
		#player.weapon.switch()
		updateResourcePoolSelf()
		updateResources()
		updateUI()
		pass
	if(Input.is_action_just_pressed("reload")):
		var currentWeaponTemp = player.weapon.get_current_weapon()
		if(resources.reload_this(currentWeaponTemp)):
			#UI.updateCurrentAmmoText(currentAmmo)
			#UI.updateCurrentReloadText(currentReloads)
			print("reloaded!")
			updateResourcePoolSelf()
			updateUI()
		else:
			print("reload fails!")
		#updateResources()
		pass
	if(Input.is_action_just_pressed("toggle")):
		if(!weapons_free):
			weapons_free = true
			print("weapons free!")
		else:
			weapons_free = false
	if(Input.is_action_pressed("fire_weapon")):
		if(weapons_free):
			#set to firepoint.
			if(currentAmmo > 0):
				#fire weapon, deduct ammo.
				currentAmmo -= 1
				updateUI()
				player.shoot()
				pass
			else:
				#no ammo, weapon doesn't fire.
				#clicking noise or something. 
				pass
			pass
		else:
			print("open weapons")
		
	
	
	
	player.get_input()

func do_Pickup(action):
	#called when a player gets a pickup
	match action:
		"TEST":
			print("test")
		"ReloadG":
			doAddReload("gatling", 1)
		"ReloadW":
			doAddReload("gatling", 1)
		"ReloadB":
			doAddReload("gatling", 1)
		"ReloadH":
			doAddReload("gatling", 1)
		"Heal":
			pass
		_:
			pass

	print(action)

func updateResources():
	#this will update the ammo amount for the specified resource. 
	#since resources are in a pool, this only needs to be called when a weapon is switched out. 
	#Needs testing!
	resources.updateThisResource(player.weapon.current_weapon, currentAmmo)
	resources.updateThisReload(player.weapon.current_weapon, currentReloads)
	pass

func updateResourcePoolSelf():
	#updates the current pool of resources from resources
	currentAmmo = resources.getThisAmmo(current_weapon)
	currentReloads = resources.getThisReload(current_weapon)


func updateUI():
	#ammo, reloads, nameW
	UI.setUpSelf(currentAmmo, currentReloads, current_weapon, health.points)
	#UI.setUpHealth()
	UI.doUIUpdate()
	
	
	
	pass


func respond():
	print("response!")

func doUIStart():
	#remove this at some point
	UI.updateCurrentAmmoText(currentAmmo)
	UI.updateCurrentReloadText(currentReloads)
	UI.updateWeaponName(current_weapon)
	UI.updateHealthText(health.points)
	pass

func doAddReload(type, amt):
	#gets the specified type of reloads and add amt to it.
	amt = amt + resources.getThisReload(type)
	resources.set_this_reload(type, amt)
	updateResourcePoolSelf()
	updateUI()

func harmSelf(amt):
	#I'm not renaming this. 
	if(health.deductHealth(amt)):
		#if true, player is dead
		#Die()
		pass
	else:
		#print(health.points)
		pass
		#updateHealthUI
	print(health.points)
	updateUI()
	
func pushPlayer(push):
	player.velocity = push * .2

func loadInPlayerResources(thing, amt):
	print(thing)
	#order does not matter. These all need to be declared in the file. 
	match thing:
		"AmmoG":
			resources.set_this_amt("gatling", amt)
			print("gat")
		"AmmoB":
			resources.set_this_amt("beam", amt)
		"AmmoW":
			resources.set_this_amt("wave", amt)
		"AmmoH":
			resources.set_this_amt("homing", amt)
		"AmmoM":
			#resources.set_this_amt("gatling", amt)
			pass
		"Health":
			health.setHealth(amt)
		"Fuel":
			#resources.set_this_amt("wave", amt)
			pass
		"ReloadG":
			resources.set_this_reload("gatling", amt)
		"ReloadB":
			resources.set_this_reload("beam", amt)
		"ReloadW":
			resources.set_this_reload("wave", amt)
		"ReloadH":
			resources.set_this_reload("homing", amt)
		"Done":
			doStartUpTasks()
		_:
			pass
	
	
	
	pass


