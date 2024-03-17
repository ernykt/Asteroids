extends CharacterBody2D

var SPEED = 100.0

var movement_vector = Vector2(0, -1)
var sizes = [self.scale, self.scale / 2, self.scale / 4]

func _ready():
	rotation = randi_range(0, PI*2)

func _physics_process(delta):
	screen_wrap()
	global_position += movement_vector.rotated(rotation) * SPEED * delta

func screen_wrap():
	if self.position.x > 1024:
		self.position.x = 0
	if self.position.x < 0:
		self.position.x = 1024
	if self.position.y < 0:
		self.position.y = 768
	if self.position.y > 768:
		self.position.y = 0

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		Globals.lives -= 1
		Globals.emit_signal("player_death")
		if Globals.lives < 0:
			body.queue_free()
	if "Bullet" in body.name:
		Globals.emit_signal("hit")
		explode(self)
		self.queue_free()
		body.queue_free()
		
func explode(object):
	if object.scale > sizes[2]:
		if object.scale == sizes[0]:
			for i in range(2):
				var medium_instance = preload("res://scenes/rock.tscn").instantiate()
				medium_instance.scale = sizes[1]
				medium_instance.position = self.position
				medium_instance.SPEED += randi_range(50,70)
				get_parent().call_deferred("add_child",medium_instance)
		if object.scale == sizes[1]:
			for i in range(2):
				var small_instance = preload("res://scenes/rock.tscn").instantiate()
				small_instance.scale = sizes[2]
				small_instance.position = self.position
				small_instance.SPEED += randi_range(100,150)
				get_parent().call_deferred("add_child",small_instance)
