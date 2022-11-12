extends Node2D
class_name Tableau

onready var cards: Node = $Cards
onready var tween: Tween = $Tween
onready var tableau_name: String = str(self.name).to_lower()
onready var card_data: Dictionary = {tableau_name: []}

signal card_added

func _ready() -> void:
	pass

func has_cards() -> bool:
	return cards.get_child_count() > 0

func get_card_count() -> int:
	return cards.get_child_count()
	
func get_cards() -> Dictionary:
	var cards_array = []
	
	for i in range(0,cards.get_child_count()):
		var card_data_point = {"int_value": cards.get_child(i).int_value, "suit": cards.get_child(i).suit, "face": cards.get_child(i).face_value, "texture": cards.get_child(i).texture_name}
		cards_array.append(card_data_point)
	
	card_data[tableau_name] = cards_array
		
	return card_data

func add_card_to_tableau(selected_card, card_offset, duration = 1):
	cards.add_child(selected_card)
	selected_card.set_owner(cards)
	selected_card.tableau = self
	tween.interpolate_property(selected_card, "position", selected_card.position, 
			Vector2(cards.get_parent().position.x, cards.get_parent().position.y + card_offset), duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	emit_signal("card_added")

func is_top_tableau_card(card) -> bool:
	var tableau_children_count = cards.get_child_count()
	return (card == cards.get_child(tableau_children_count - 1))

func get_top_tableau_card() -> Node:
	var tableau_children_count = cards.get_child_count()
	return cards.get_child(tableau_children_count - 1)
