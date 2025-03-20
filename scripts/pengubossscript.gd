extends CharacterBody2D
#this is boss scriptet
#@export var chest_scene: PackedScene

var speed = 500
var player = null
var inshortAttackZone = false
var inlongAttackZone = false
var attacking = false
var mobhp = 500
var dieing = false
var direction = Vector2.ZERO
var jumping = false
@export var chest_scene: PackedScene
@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0
var rng = RandomNumberGenerator.new()
var shake_strength: float = 8.0
var player_camera = null
var nearby_enemies: Array = [] ######################

func _ready():
	add_to_group("mebs")
	player = get_node("/root/Node2D/player") 
	player_camera = player.get_node("Camera2D")
	$longattack.body_entered.connect(_on_Area2D_body_entereds)
	$longattack.body_exited.connect(_on_Area2D_body_exiteds)
	$shortattack.body_entered.connect(_on_Area2D_body_entered)
	$shortattack.body_exited.connect(_on_Area2D_body_exited)
	$pushArea.body_entered.connect(_on_push_area_body_entered)###############
	$pushArea.body_exited.connect(_on_push_area_body_exited) ##############
	_attack_loop1()
	_attack_loop2()

func _physics_process(_delta):
	if not inshortAttackZone and not inlongAttackZone and not attacking and not dieing and is_instance_valid(player): 
		direction = (player.global_position - global_position).normalized()
		if not jumping:
			jump()

		# Apply velocity to movement
		move_and_slide()
		
# Flip sprite based on direction
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = true
	if shake_strength > 0 and is_instance_valid(player):
		shake_strength = lerpf(shake_strength, 0, shakeFade * _delta)
		
		player_camera.offset = random0ffset()
	
	for enemy in nearby_enemies:
		if enemy and enemy != self:
			var push_dir = (enemy.global_position - global_position).normalized()
			if enemy.has_method("apply_push_force"):  # safer
				enemy.apply_push_force(push_dir * 100)  # You can tweak force here

	
	
	
	
	
func jump():
	jumping = true
	$longattack/CollisionShape2D.disabled = true
	$shortattack/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("run")
	await get_tree().create_timer(0.1).timeout
	
	velocity = direction * speed
	await get_tree().create_timer(0.5).timeout

	velocity = Vector2.ZERO
	$impact.visible = true
	$impact.play("impact")
	apply_shake()
	await $AnimatedSprite2D.animation_finished
	$longattack/CollisionShape2D.disabled = false
	$shortattack/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.1).timeout
	$impact.visible = false
	jumping = false
		

func _attack_loop1() -> void:
	while true:
		await get_tree().process_frame
		if inshortAttackZone and not attacking and not dieing and not jumping:
			attacking = true
			$AnimatedSprite2D.play("attackclose")
			await get_tree().create_timer(0.50).timeout
			if inshortAttackZone and player:  # optional check
				player.hit()
			await get_tree().create_timer(0.82).timeout
			attacking = false
		else:
			attacking = false

func _attack_loop2() -> void:
	while true:
		await get_tree().process_frame
		if inlongAttackZone and not attacking and not dieing and not inshortAttackZone and not jumping:
			attacking = true
			$AnimatedSprite2D.play("attacklong")
			await get_tree().create_timer(0.65).timeout
			if inlongAttackZone and player:  # optional check
				player.hit()
			await get_tree().create_timer(0.47).timeout
			attacking = false
		else:
			attacking = false

func _on_Area2D_body_entered(body):
	if body == player:
		inshortAttackZone = true

func _on_Area2D_body_exited(body):
	if body == player:
		inshortAttackZone = false

func _on_Area2D_body_entereds(body):
	if body == player:
		inlongAttackZone = true

func _on_Area2D_body_exiteds(body):
	if body == player:
		inlongAttackZone = false



func mobhit(Damage):
	mobhp -= Damage
	if mobhp <= 0 and not dieing:
		dieing = true
		$AnimatedSprite2D.play("die")
		#spawn_xp()
		$CollisionShape2D.call_deferred("set_disabled", true)
		var main = get_tree().current_scene
		main.kill()
		await get_tree().create_timer(2).timeout
		var existing_chest = get_tree().get_nodes_in_group("chests")  # Assuming chests are in a "chests" group
		if existing_chest.size() == 0 and chest_scene:  # No chest exists and chest_scene is assigned
			var chest = chest_scene.instantiate()
			chest.global_position = global_position
			var g = get_parent()
			g.get_parent().add_child.call_deferred(chest)
		
		var a = get_parent()
		a.queue_free()


#func spawn_xp(): make it chest sapawn thinghy
	#var xp = xp_scene.instantiate()
	#xp.global_position = global_position
	#get_tree().current_scene.call_deferred("add_child", xp)
	
	
func _on_push_area_body_entered(body):
	# Only push other enemies (exclude player or self)
	if body != self and body is CharacterBody2D:
		nearby_enemies.append(body)

func _on_push_area_body_exited(body):
	nearby_enemies.erase(body)
	

	
	



func apply_shake():
	shake_strength = randomStrength

func random0ffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))








		
