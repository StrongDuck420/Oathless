extends Node2D

var mebs = null

func _ready() -> void:
	mebs = get_tree().get_nodes_in_group("mebs")
	for meb in mebs:
		meb.queue_free()
