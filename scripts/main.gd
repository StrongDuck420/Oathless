extends Node2D

@export var mob_scene: PackedScene
@export var mushroom_scene: PackedScene
@export var boss_scene: PackedScene
@export var spawn_radius: float = 900.0
@export var mobs_per_spawn: int = 1
@export var mmobs_per_spawn: int = 0

@onready var player = get_node("player") # Change path to your actual player node

func _ready():
	spawn_mobs() # Initial spawn
	progression()
	

func spawn_mobs():
	if player == null:
		return
	
	for i in range(mobs_per_spawn):
		var mob = mob_scene.instantiate()
		
		# Generate a random angle and distance from the player
		var angle = randf() * TAU
		var distance = randf_range(spawn_radius * 0.5, spawn_radius)
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
	$orcmobtimer.wait_time = 2
	await get_tree().create_timer(10).timeout
	$orcmobtimer.wait_time = 1
	await get_tree().create_timer(10).timeout
	mmobs_per_spawn = 1
	await get_tree().create_timer(10).timeout
	$orcmobtimer.wait_time = 1.5
	mobs_per_spawn = 2
	$mmobtimer.wait_time = 4
	await get_tree().create_timer(10).timeout
	$orcmobtimer.wait_time = 1
	$mmobtimer.wait_time = 3
	await get_tree().create_timer(10).timeout
	spawn_boss()
	await get_tree().create_timer(30).timeout
	infinity = true
	var fasterm = 0.1
	var fastermm = 0.1
	while infinity == true:
		await get_tree().create_timer(5).timeout
		$orcmobtimer.wait_time -= fasterm
		$mmobtimer.wait_time -= fastermm
		if $orcmobtimer.wait_time == 0.1:
			fasterm = 0.01
		if $mmobtimer.wait_time == 0.1:
			fastermm = 0.01
		if $orcmobtimer.wait_time == 0.01:
			fasterm = 0.001
		if $mmobtimer.wait_time == 0.01:
			fastermm = 0.001





func _on_mmobtimer_timeout() -> void:
	spawn_mmobs()
func _on_orcmobtimer_timeout() -> void:
	spawn_mobs()
