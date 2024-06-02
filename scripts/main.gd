# main.gd
# This is the main scene script. It extends Node and is used for global variables.
# This script is set up as an Autoload to ensure these variables and functions are accessible globally.
extends Node

# Global variable to track if the player is currently attacking
var player_current_attack = false
var label_good_game = null

func _ready():
	"""
	Called when the node is added to the scene.
	This function can be used to initialize any necessary data or state.
	"""
	pass

#It may be used for load something in the process, or background
func _process(delta):
	"""
	Called every frame. The delta parameter is the elapsed time since the previous frame.
	
	Args:
		delta (float): Time elapsed since the last frame.
		
	This function can be used to perform tasks that need to be updated every frame, 
	such as loading assets in the background.
	"""
	pass
