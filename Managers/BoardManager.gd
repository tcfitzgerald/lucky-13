extends Node

var is_card_selected : bool = false
var selected_card
var _seed : int
var moves : Array
enum difficulty_type {NORMAL, HARD}
var difficulty = difficulty_type.NORMAL

func _ready() -> void:
	pass
