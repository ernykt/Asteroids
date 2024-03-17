extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 3

var bullet = preload("res://scenes/bullet.tscn")
var rocks = preload("res://scenes/rock.tscn")

var bullet_speed = 1000
var rotation_direction = 0
var a = 10.0
var is_alive = true

func _ready():
	Globals.connect("player_death", _respawn_signal)
	Globals.connect("hit", _on_hit_sound)
	$"../GameOver".visible = false

func _physics_process(delta):
	if not is_alive and $DeathTimer.is_stopped():
		$PlayerSprite.play("default")
		is_alive = true
		self.position = Vector2(1024/2, 768/2)
		self.collision_layer = 1
		self.collision_mask = 1
		$PlayerPolygon.disabled = false
	if Globals.lives < 0:
		$"../GameOver".visible = true
	rotation += rotation_direction * rotation_speed * delta
	screen_wrap()
	get_input()
	move_and_slide()

func _process(delta):
	Globals.pos = self.global_position
func get_input():
	if is_alive:
		rotation_direction = Input.get_axis("ui_left", "ui_right")
		var input_vector = Input.get_axis("ui_up", "ui_down")
		if input_vector == -1:
			velocity += Vector2(0, -1).rotated(rotation) * a
		if input_vector == 0:
			velocity = velocity.move_toward(Vector2.ZERO, 3)
		if Input.is_action_just_pressed("ui_select"):
			shoot()

func screen_wrap():
	if self.position.x > 1024:
		self.position.x = 0
	if self.position.x < 0:
		self.position.x = 1024
	if self.position.y < 0:
		self.position.y = 768
	if self.position.y > 768:
		self.position.y = 0

func shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = self.position
	bullet_instance.apply_impulse(Vector2(0, -bullet_speed).rotated(rotation))
	$ShootSound.play()
	get_parent().add_child(bullet_instance, true)

func _respawn_signal():
	print(Globals.lives)
	$DeathSound.play()
	is_alive = false
	velocity = Vector2.ZERO
	self.collision_layer = 8
	self.collision_mask = 8
	$PlayerSprite.play("death")
	$DeathTimer.one_shot = true
	$DeathTimer.start(2)

func _on_hit_sound():
	$HitSound.play()
