extends Node2D

func get_input():
	if Input.is_action_just_pressed("ui_page_up"):
		get_parent().get_tree().reload_current_scene()
		Globals.lives = 3
func _process(delta):
	get_input()
