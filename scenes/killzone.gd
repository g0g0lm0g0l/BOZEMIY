extends Area2D

@onready var timer = $Timer

func _ready():
	pass

func _process(delta):
	pass


func _on_body_entered(body):
	print("fin")
	timer.start()


func _on_timer_timeout():
	#TODO: implement replay of reload another scene or menu!!!
	get_tree().reload_current_scene()