extends Node
#The main.gd script would then serve as the primary controller of the game.

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene_tree = get_tree()
	scene_tree.change_scene_to_file("res://scenes/player.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
