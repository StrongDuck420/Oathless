extends Node
#global scirpt which i only use for saving... unfortunately
var save_data:SaveData

func _ready():
	save_data = SaveData.load_or_create()
