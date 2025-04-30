extends Sprite2D
#death screen
func _ready():
	get_viewport().connect("size_changed", _on_viewport_size_changed)
	adjust_to_screen()
	self.self_modulate.a = 0.5

func _on_viewport_size_changed():
	adjust_to_screen()

func adjust_to_screen():
	var screen_size = get_viewport_rect().size
	var texture_size = texture.get_size()
	var scale_x = screen_size.x / texture_size.x / 1.2
	var scale_y = screen_size.y / texture_size.y /1.2
	
	scale = Vector2(scale_x, scale_y)
	position = screen_size / 2
