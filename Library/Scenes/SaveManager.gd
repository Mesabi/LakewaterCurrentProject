extends Node2D


var save1
var save2
var save3

var saveAuto
#before doing anything with this, you'll need to move the saves somewhere in the hardware
#however the fuck you're supposed to do that. 
var file = "res://Saves/Save1.txt"
var filePos = "player"
var fileSwitch = ["location", "player", "events"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func testSaveLoad():
	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		readLine(line)
	f.close()
	return

func readFile():
	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		readLine(line)
	f.close()
	return

func readLine(line):
	var myArray = line.split("|")
	match filePos:
		"location":
			match myArray[0]:
				"Position ":
					loadCurrentLevel()
				"Level ":
					loadCurrentLevel()
			if(myArray[0]=="Position "):
				print("successful")
		"player":
			if(myArray.size() == 2):
				loadPlayer(myArray[0],myArray[1])
		"events":
			print("eveny")
		




func CreateAllFromSave():
	#world = get_tree()
	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		if(line.length()>3):#weeds out end lines, broken data, etc.
			createAPet(line)
			index += 1
	f.close()
	return
	
func createAPet(line):
	#creates a pet from a save file line
	var split = line.split("|")
	var count = 0
	#trim empty spaces.
	for s in split:
		var str_result = s
		var unwanted_chars = [".",",",":","?"," "]
		for c in unwanted_chars:
			split[count] = str_result.replace(c,"")
		count += 1
	#var pet = newPet.instance()
	#self.get_parent().add_child(pet)
	#(pid, Pname, age, color, location)
	#pet.set_me_up(-1, split[0], int(split[2]), split[1], self.position)

func saveFile(Pets):
	var fileNew = File.new()
	fileNew.open(file, File.WRITE)
	for pet in Pets:
		fileNew.store_line(pet.returnInfo())
	fileNew.close()
	pass

func loadCurrentLevel():
	pass

func loadPlayer(thing, amt):
	#this works assuming you don't add more addons, or move world manager in the hierarchy.
	#OR GLOBALS -.-
	#print("here")
	#print(get_tree().get_root().get_child(3).get_child(0)) #<- test for where worldmanger is
	get_tree().get_root().get_child(3).get_child(1).loadInPlayerResources(thing, amt)
	
	pass
	
func loadGameGlobals():
	pass
