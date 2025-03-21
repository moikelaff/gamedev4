extends LinkButton

@export var level_to_load: String

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/" + level_to_load + ".tscn")
