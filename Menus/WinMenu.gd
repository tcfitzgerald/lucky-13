extends Popup


func _ready() -> void:
	pass


func _on_NewGameButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Board/Board.tscn")


func _on_MainMenuButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/MainMenu.tscn")
