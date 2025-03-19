extends Area2D

@export var randomStrength: float = 3.0
@export var shakeFade: float = 5.0
var rng = RandomNumberGenerator.new()
var shake_strength: float = 3.0
var player_camera = null
@onready var laser_root = get_parent() 
var mobs = []  
var player = null
@onready var main_scene = get_node("/root/Node2D")
@onready var lastheart = main_scene.get_node("CanvasLayer/halfhear 1")
var Damage = null

func _ready() -> void:
	self.body_entered.connect(_on_Area2D_body_entered)
	self.body_exited.connect(_on_Area2D_body_exited) 
	player = get_node("/root/Node2D/player")
	player_camera = player.get_node("Camera2D")
	timeleft()
	damage_loop() 
	

func _process(_delta):
	var direction = get_global_mouse_position() - laser_root.global_position
	laser_root.rotation = direction.angle()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * _delta)
		
		player_camera.offset = random0ffset()
	apply_shake()
	if not lastheart.visible:
		queue_free()


func set_damage(damage):
	Damage = damage

func timeleft():
	await get_tree().create_timer(5).timeout
	queue_free()

func _on_Area2D_body_entered(body):
	if body != player:
		mobs.append(body)

func _on_Area2D_body_exited(body):
	if body in mobs:
		mobs.erase(body)  

func damage_loop():
	while true:
		if mobs.size() > 0: 
			for mob in mobs.duplicate():  
				if mob and mob.has_method("mobhit"): 
					mob.mobhit(Damage)
				else:
					mobs.erase(mob)
		await get_tree().create_timer(0.1).timeout















func apply_shake():
	shake_strength = randomStrength

func random0ffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
