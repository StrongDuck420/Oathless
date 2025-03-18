extends Area2D

var player = null
var entered = false

func _ready():
	player = get_node("/root/Node2D/player") 
	await get_tree().create_timer(0.4).timeout
	self.body_entered.connect(_on_Area2D_body_entered)

func _physics_process(_delta):
	$AnimationPlayer.play("float")
	await get_tree().create_timer(1).timeout
	
	
func _on_Area2D_body_entered(body):
	if body == player:
		player.pickedlightning()
		queue_free()
