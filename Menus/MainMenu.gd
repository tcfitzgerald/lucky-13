extends Control

onready var transition = $SceneTransition

func _ready() -> void:
	pass


func _on_PlayButton_pressed() -> void:
	transition.transition_to()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
