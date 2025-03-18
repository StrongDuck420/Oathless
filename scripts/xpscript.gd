extends Area2D

var player = null
var entered = false

func _ready():
	player = get_node("/root/Node2D/player") 
	self.body_entered.connect(_on_Area2D_body_entered)
	$collect.body_entered.connect(_on_collect_body_entered)

func _physics_process(_delta):
	if entered == true:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * 200 * _delta

func _on_Area2D_body_entered(body):
	if body == player:
		entered = true
		
func _on_collect_body_entered(body):
	if body == player:
		player.levelup()
		queue_free()
