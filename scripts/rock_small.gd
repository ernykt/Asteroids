extends CharacterBody2D

const SPEED = 300.0

var movement_vector = Vector2(0, -1)

func _ready():
	rotation = randi_range(0, PI*2)

func _physics_process(delta):
	screen_wrap()
	global_position += movement_vector.rotated(rotation) * SPEED * delta

func screen_wrap():
	if self.position.x > 800:
		self.position.x = 0
	if self.position.x < 0:
		self.position.x = 800
	if self.position.y < 0:
		self.position.y = 600
	if self.position.y > 600:
		self.position.y = 0
