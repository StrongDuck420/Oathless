extends Node2D

@export var mob_scene: PackedScene
@export var spawn_radius: float = 700.0
@export var mobs_per_spawn: int = 1
@export var spawn_interval: float = 5.0

@onready var player = get_node("player") # Change path to your actual player node

func _ready():
	
	
	# Spawn mobs every few seconds using a timer
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(spawn_mobs)
	add_child(spawn_timer)
	spawn_mobs() # Initial spawn

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
