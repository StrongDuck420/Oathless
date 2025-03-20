extends Sprite2D
func _ready():
	get_viewport().connect("size_changed", _on_viewport_size_changed)
	adjust_to_screen()
	self.self_modulate.a = 0.3

func _on_viewport_size_changed():
	adjust_to_screen()

func adjust_to_screen():
	# Get viewport size
	var screen_size = get_viewport_rect().size
	
	# Get texture size
	var texture_size = texture.get_size()
	
	# Calculate scale factors for both dimensions
	var scale_x = screen_size.x / texture_size.x
	var scale_y = screen_size.y / texture_size.y
	
	# Apply scale to stretch to full screen (no min/max, separate scales for x and y)
	scale = Vector2(scale_x, scale_y)
	
	# Center the sprite
	position = screen_size / 2
