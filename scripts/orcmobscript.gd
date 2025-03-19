extends CharacterBody2D
#this is mob scriptet
@export var xp_scene: PackedScene

var speed = 200
var player = null
var inAttackZone = false
var attacking = false
var mobhp = 100
var dieing = false
var hitani = false
var push_force: Vector2 = Vector2.ZERO

func _ready():
	player = get_node("/root/Node2D/player") 
	$Area2D.body_entered.connect(_on_Area2D_body_entered)
	$Area2D.body_exited.connect(_on_Area2D_body_exited)
	_attack_loop()
	
func _physics_process(_delta):
	if not inAttackZone and not attacking and not dieing and is_instance_valid(player): 
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed + push_force
		move_and_slide()
		push_force = lerp(push_force, Vector2.ZERO, 10 * _delta)
		if not hitani:
			$AnimatedSprite2D.play("run")
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = true
	else:
		push_force = lerp(push_force, Vector2.ZERO, 10 * _delta)
		velocity = push_force
		move_and_slide()
		
	if is_instance_valid(player): #fixes werif bug that makes the game crash
		var space = player.global_position.distance_to(global_position)
		if space > 1000:
			print("removed 1")
			queue_free()

func _attack_loop() -> void:
	while true:
		await get_tree().process_frame
		if inAttackZone and not attacking and not dieing:
			attacking = true
			$AnimatedSprite2D.play("attack")
			await get_tree().create_timer(0.42).timeout
			if inAttackZone and player:  # optional check
				player.hit()
			await get_tree().create_timer(0.30).timeout
			attacking = false
		else:
			attacking = false

func _on_Area2D_body_entered(body):
	if body == player:
		inAttackZone = true

func _on_Area2D_body_exited(body):
	if body == player:
		inAttackZone = false



func mobhit(Damage):
	mobhp -= Damage
	if mobhp > 0:
		hitani = true
		$AnimatedSprite2D.play("hit")
		await get_tree().create_timer(0.4).timeout
		hitani = false
	if mobhp <= 0 and not dieing:
		dieing = true
		$AnimatedSprite2D.play("die")
		spawn_xp()
		$CollisionShape2D.call_deferred("set_disabled", true)
		var main = get_tree().current_scene
		main.kill()
		await get_tree().create_timer(2.60).timeout
		var a = get_parent()
		a.queue_free()


func spawn_xp():
	var xp = xp_scene.instantiate()
	xp.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", xp)
	
	
	
	
	
	
	
func apply_push_force(force: Vector2):
	push_force += force
