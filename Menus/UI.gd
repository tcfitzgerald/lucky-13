extends CanvasLayer

signal undo_button_pressed
signal hint_button_pressed

func _ready() -> void:
	pass


func _on_HintButton_pressed() -> void:
	emit_signal("hint_button_pressed")


func _on_UndoButton_pressed() -> void:
	emit_signal("undo_button_pressed")
