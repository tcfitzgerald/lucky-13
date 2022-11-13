extends Node

var card_node
var card_data
var card_parent
var current_position
var action


func _init(_card, _card_data, _card_parent, _current_position, _action) -> void:
	card_node = _card
	card_data = _card_data
	card_parent = _card_parent
	current_position = _current_position
	action = _action

func _ready() -> void:
	pass
