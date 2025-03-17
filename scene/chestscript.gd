extends Area2D

@export var lightning_scene: PackedScene
var open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_on_Area2D_body_entereds)
	$AnimatedSprite2D.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		z_index = int(global_position.y)

func _on_Area2D_body_entereds(_body):
	if not open:
		$AnimatedSprite2D.play("open")
		await get_tree().create_timer(0.5).timeout
		open = true
		var pickup = lightning_scene.instantiate()
		pickup.global_position = Vector2(0, -80)

		get_parent().add_child.call_deferred(pickup)
