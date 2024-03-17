extends Node2D


func _on_kill_explosion_timeout():
	self.queue_free()
