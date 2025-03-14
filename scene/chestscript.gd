extends Area2D

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
		open = true
