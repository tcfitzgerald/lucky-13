extends ColorRect

export(String, FILE, "*.tscn") var next_scene_path

onready var animation = $TransitionAnim

func _ready() -> void:
	animation.play_backwards("Fade")
	
func transition_to(_next_scene := next_scene_path) -> void:
	animation.play("Fade")
	yield(animation, "animation_finished")
# warning-ignore:return_value_discarded
	get_tree().change_scene(_next_scene)
