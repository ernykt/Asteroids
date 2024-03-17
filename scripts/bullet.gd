extends RigidBody2D

func _on_bullet_timer_timeout():
	self.queue_free()
