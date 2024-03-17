extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5

var bullet = preload("res://scenes/bullet.tscn")
var rocks = [preload("res://scenes/rock.tscn"),preload("res://scenes/rock_medium.tscn"), preload("res://scenes/rock_small.tscn")]

var y_pos = [-40, -50, -60]
var bullet_speed = 500
var rotation_direction = 0
var a = 10.0

func _physics_process(delta):
	screen_wrap()
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	var input_vector = Input.get_axis("ui_up", "ui_down")
	if input_vector == -1:
		velocity += Vector2(0, -1).rotated(rotation) * a
	if input_vector == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	if Input.is_action_just_pressed("ui_select"):
		shoot()
	if Input.is_action_just_pressed("ui_page_up"):
		get_parent().get_tree().reload_current_scene()

func screen_wrap():
	if self.position.x > 800:
		self.position.x = 0
	if self.position.x < 0:
		self.position.x = 800
	if self.position.y < 0:
		self.position.y = 600
	if self.position.y > 600:
		self.position.y = 0

func shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = self.position
	bullet_instance.apply_impulse(Vector2(0, -bullet_speed).rotated(rotation))
	get_parent().add_child(bullet_instance, true)
