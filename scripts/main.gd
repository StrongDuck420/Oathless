extends Node2D

@export var mob_scene: PackedScene
@export var mushroom_scene: PackedScene
@export var boss_scene: PackedScene
@export var spawn_radius: float = 900.0
@export var mobs_per_spawn: int = 1
@export var mmobs_per_spawn: int = 0
var level = null

@onready var player = get_node("player") # Change path to your actual player node

func _ready():
	spawn_mobs() # Initial spawn
	level = get_node("/root/Node2D/CanvasLayer/level/VBoxContainer/kills")
	progression()

func spawn_mobs():
	if player == null:
		return
	
	for i in range(mobs_per_spawn):
		var mob = mob_scene.instantiate()
		
		# Generate a random angle and distance from the player
		var angle = randf() * TAU
		var distance = randf_range(spawn_radius * 1, spawn_radius)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		mob.global_position = player.global_position + offset

		get_parent().add_child.call_deferred(mob)
		
func spawn_mmobs():
	if player == null:
		return

	for i in range(mmobs_per_spawn):
		var mob = mushroom_scene.instantiate()
		
		# Generate a random angle and distance from the player
		var angle = randf() * TAU
		var distance = randf_range(spawn_radius * 0.5, spawn_radius)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		mob.global_position = player.global_position + offset

		get_parent().add_child.call_deferred(mob)
		
func spawn_boss():
	if player == null:
		return

	for i in range(1):
		var mob = boss_scene.instantiate()
		
		# Generate a random angle and distance from the player
		var angle = randf() * TAU
		var distance = randf_range(spawn_radius * 0.5, spawn_radius)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		mob.global_position = player.global_position + offset

		get_parent().add_child.call_deferred(mob)
		
		
func kill():
	var kills = get_node("/root/Node2D/CanvasLayer/MarginContainer/VBoxContainer/kills")
	kills.text = str(int(kills.text) + 1)
	
	
	


func progression():
	var infinity = false
	await get_tree().create_timer(10).timeout
	level.text = "Level " + str(2)
	$orcmobtimer.wait_time = 2
	await get_tree().create_timer(10).timeout
	level.text = "Level " + str(3)
	$orcmobtimer.wait_time = 1
	await get_tree().create_timer(10).timeout
	level.text = "Level " + str(4)
	mmobs_per_spawn = 1
	await get_tree().create_timer(10).timeout
	level.text = "Level " + str(5)
	$orcmobtimer.wait_time = 1.5
	mobs_per_spawn = 2
	$mmobtimer.wait_time = 4
	await get_tree().create_timer(10).timeout
	level.text = "Level " + str(6)
	$orcmobtimer.wait_time = 1
	$mmobtimer.wait_time = 3
	await get_tree().create_timer(10).timeout
	level.text = "Level Boss"
	spawn_boss()
	await get_tree().create_timer(30).timeout
	level.text = "Level infinity"
	infinity = true
	while infinity == true:
		await get_tree().create_timer(10).timeout
		$orcmobtimer.wait_time *= 0.9  # 10% decrease
		$mmobtimer.wait_time *= 0.9
		if randf() < 0.20:
			spawn_boss()




func _on_mmobtimer_timeout() -> void:
	spawn_mmobs()
func _on_orcmobtimer_timeout() -> void:
	spawn_mobs()
