extends CharacterBody2D
#player scriptet
@export var speed = 250
@export var projectile : PackedScene
var heart_images = []
var current_heart_index = 0
var dead = false
var shootdelay = false

func _ready():
	var main_scene = get_node("/root/Node2D")
	heart_images.append(main_scene.get_node("CanvasLayer/heart 3"))
	heart_images.append(main_scene.get_node("CanvasLayer/halfhear 3"))
	heart_images.append(main_scene.get_node("CanvasLayer/heart 2"))
	heart_images.append(main_scene.get_node("CanvasLayer/halfhear 2"))
	heart_images.append(main_scene.get_node("CanvasLayer/heart 1"))

func get_input():
	if not dead:
		var input_direction = Input.get_vector("left", "right", "up", "down")
		velocity = input_direction * speed

		if Input.is_action_just_pressed("shoot"):
			shoot()

		if Input.is_action_just_pressed("left"):
			$hooded.flip_h = true
		if Input.is_action_just_pressed("right"):
			$hooded.flip_h = false
	else:
		velocity = Vector2.ZERO

#process your moving i guess
func _physics_process(_delta):
	get_input()
	move_and_slide()
	z_index = int(global_position.y)
	if not dead:
		if velocity.length() > 0:
			$hooded.play("running")
		else:
			$hooded.play("idle")

func shoot():
	if not shootdelay:
		shootdelay = true
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
		await get_tree().create_timer(0.2).timeout
		shootdelay = false

func hit():
	if current_heart_index < heart_images.size():
		heart_images[current_heart_index].visible = false
		current_heart_index += 1
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play("blood1")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.visible = false
	else:
		if not dead:
			dead = true
			$hooded.play("dead")
			var main_scene = get_node("/root/Node2D")
			var lastheart = main_scene.get_node("CanvasLayer/halfhear 1")
			lastheart.visible = false
		
		
