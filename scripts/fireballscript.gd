extends Area2D

var speed = 800
var Damage = null


func _ready():	
	self.body_entered.connect(_on_Area2D_body_entered)
	outofbody()

func _physics_process(delta):
	position += transform.x * speed * delta

func set_damage(damage):
	Damage = damage

func _on_Area2D_body_entered(body):
	if body.has_method("mobhit"):
		body.mobhit(Damage)
		$AnimatedSprite2D.play("boom")
		await $AnimatedSprite2D.animation_finished
		queue_free()  # Optional: destroy bullet on hit
# make damagae animation and explosion animation and hit sound

func outofbody():
	$AnimatedSprite2D.visible = false
	await get_tree().create_timer(0.05).timeout
	$AnimatedSprite2D.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
