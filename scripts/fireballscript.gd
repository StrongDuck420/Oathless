extends Area2D

var speed = 800

func _ready():	
	self.body_entered.connect(_on_Area2D_body_entered)

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Area2D_body_entered(body):
	if body.has_method("mobhit"):
		body.mobhit()
		$AnimatedSprite2D.play("boom")
		await $AnimatedSprite2D.animation_finished
		queue_free()  # Optional: destroy bullet on hit
# make damagae animation and explosion animation and hit sound


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
