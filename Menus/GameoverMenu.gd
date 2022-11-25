extends Popup

signal undo_last_move_button_clicked

func _ready() -> void:
	pass


func _on_NewGameButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Board/Board.tscn")


func _on_MainMenuButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/MainMenu.tscn")


func _on_UndoLastMoveButton_pressed() -> void:
	hide()
	emit_signal("undo_last_move_button_clicked")
