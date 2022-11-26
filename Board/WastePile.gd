extends Node2D
class_name WastePile

onready var card_holder : Node = $Cards
onready var tween : Tween = $Tween
onready var z_index_tween: Tween = $z_index_tween

signal check_board_state

func _ready() -> void:
	pass

func move_cards_to_waste_pile(cards, play_tween = true, play_flip = false):
	for card in cards:
		var parent = card.get_parent()
		parent.remove_child(card)
		card_holder.add_child(card)
		card.set_owner(card_holder)
		card.card_type = "wastepile"
		if play_tween:
	# warning-ignore:return_value_discarded
			tween.interpolate_property(card, "position", card.position, card_holder.get_parent().position, 1, 
				Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
			z_index_tween.interpolate_property(card, "z_index", 90, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
			tween.start()
			z_index_tween.start()

		elif play_flip:
	# warning-ignore:return_value_discarded
			tween.interpolate_property(card, "position", parent.get_parent().position, card_holder.get_parent().position, 1, 
				Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	# warning-ignore:return_value_discarded
			tween.start()

		else:
			card.position = card_holder.get_parent().position

	emit_signal("check_board_state")
