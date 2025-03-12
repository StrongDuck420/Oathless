extends CharacterBody2D
#player scriptet
@export var speed = 250
@export var projectile : PackedScene
var heart_images = []
var current_heart_index = 0

func _ready():
	var main_scene = get_node("/root/Node2D")
	heart_images.append(main_scene.get_node("CanvasLayer/heart 3"))
	heart_images.append(main_scene.get_node("CanvasLayer/halfhear 3"))
	heart_images.append(main_scene.get_node("CanvasLayer/heart 2"))
	heart_images.append(main_scene.get_node("CanvasLayer/halfhear 2"))
	heart_images.append(main_scene.get_node("CanvasLayer/heart 1"))
	heart_images.append(main_scene.get_node("CanvasLayer/halfhear 1"))

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if Input.is_action_just_pressed("shoot"):
		shoot()

	if Input.is_action_just_pressed("left"):
		$hooded.flip_h = true
	if Input.is_action_just_pressed("right"):
		$hooded.flip_h = false

#process your moving i guess
func _physics_process(_delta):
	get_input()
	move_and_slide()
	if velocity.length() > 0:
		$hooded.play("running")
	else:
		$hooded.play("idle")

func shoot():
	var p = projectile.instantiate()
	owner.add_child(p)
	#start at player pos
	var start_pos = global_position
	p.global_position = start_pos
	var mouse_pos = get_global_mouse_position()

	# Calculate direction towards mouse position
	var direction = (mouse_pos - start_pos).normalized()
	# Set the velocity of the projectile
	# Set direction in the projectile
	p.rotation = direction.angle()

func hit():
	if current_heart_index < heart_images.size():
		heart_images[current_heart_index].visible = false
		current_heart_index += 1
	else:
		print("dead")	
