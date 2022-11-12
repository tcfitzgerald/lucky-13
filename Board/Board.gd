extends Control
class_name Board

var card_offset: int = 50
var tableau_count: int = 5
var overflow_tableau_count: int = 2
var cards_per_tableau: int = 1

var available_moves: Array = []
var playable_cards: Array = []


func _ready() -> void:
	pass
