extends Node
#on game load, these values will need to be updated. 

#so currently the issue with how this is set up, is that there are tons of "small" fields controlled
#by various states. 

#this is an issue, since a save file will need to iterate all of these on read. 
#for the moment, they're being stored in blocks.

###Block 1###
#used to store immediately relevant info. 
var Block1 = []
var currentLevel = "GD4Test-01"
var currentCheckpoint = "01"#"undefined"#if this is set to undefined, this will spawn player @ 0,0
var healthOnLastSave = 100 #remove if we go for dark souls thing.

###Block 2###
#used to store player inventory, state, etc.
var Block2 = []


###Block 3###
#used to store world state globals. 


###Block 4###
#used to store conversation choice info. 






func getBlock1():
	Block1 = [currentLevel, currentCheckpoint, str(healthOnLastSave)]
	#print(Block1)
	return Block1
	pass
	
func setBlock1():
	pass


var has_met_nathan: bool = false






var num = 0

var some_variable = 0

var defiance = 0#refusal to do what is asked.

var obedience = 0#doing what has been asked <- and is observed

var trust = 0 #how much the player is trusted.

var scars = 0#global total damage count.


