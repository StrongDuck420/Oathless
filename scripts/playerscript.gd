extends CharacterBody2D
#player scriptet
@export var speed = 250
@export var projectile : PackedScene
@export var lightning_scene: PackedScene
var heart_images = []
var current_heart_index = 0
var dead = false
var shootdelay = false
var cooldown = false
var lightningpicked = false 
var main_scene = null
var lightcountdownnnnn = false
var cooldowntext = null
var xp = 0
var damage = 20

func _ready():
	main_scene = get_node("/root/Node2D")
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
		if Input.is_action_just_pressed("laser"):
			laser()

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
		p.set_damage(damage)
		await get_tree().create_timer(0.2).timeout
		shootdelay = false
		
func laser():
	if lightningpicked:
		if not lightcountdownnnnn:
			if not cooldown:
				cooldown = true
				var l = lightning_scene.instantiate()
				add_child(l)
				l.position = Vector2.ZERO
				l.rotation = (get_global_mouse_position() - global_position).angle()
				l.get_node("Area2D").set_damage(damage)
				await get_tree().create_timer(5).timeout
				lightcountdown()
				cooldown = false 

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
			main_scene = get_node("/root/Node2D")
			var lastheart = main_scene.get_node("CanvasLayer/halfhear 1")
			lastheart.visible = false
			$levelup.visible = false
			$finallevel.visible = false
		

func pickedlightning():
	lightningpicked = true
	var lightningimage = main_scene.get_node("CanvasLayer/lightning")
	cooldowntext = main_scene.get_node("CanvasLayer/cooldown/VBoxContainer/timer")
	lightningimage.visible = true
	cooldowntext.visible = true

func lightcountdown():
	lightcountdownnnnn = true
	var time_left = 10

	while time_left > 0:
		cooldowntext.text = str(time_left) + "s" 
		await get_tree().create_timer(1).timeout
		time_left -= 1
	
	cooldowntext.text = "E"
	lightcountdownnnnn = false
	cooldown = false 

func levelup():
	xp += 1
	if xp == 5:
		$levelup.play("1")
		$levelup.visible = true
		damage = 25
	if xp == 15:
		$levelup.play("2")
		damage = 34
	if xp == 35: 
		$levelup.play("3")
		damage = 50
	if xp == 75:  
		$levelup.play("4")
		damage = 100
	if xp == 155:
		$levelup.visible = false
		$finallevel.play("1")
		$finallevel.visible = true
		damage = 200
