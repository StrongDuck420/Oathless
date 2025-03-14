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
	z_index = int(global_position.y)
	if not inAttackZone and not attacking and not dieing: 
		#var direction = (player.global_position - global_position).normalized()
		#global_position += direction * speed * _delta
		var direction = (player.global_position - global_position).normalized()
		#velocity = direction * speed
		velocity = direction * speed + push_force
		move_and_slide()
		push_force = lerp(push_force, Vector2.ZERO, 10 * _delta)  # smooth decay
		if not hitani:
			#$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.play("run")
# Flip sprite based on direction
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = true

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



func mobhit():
	mobhp -= 25
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
	print("Received push force: ", force)
