extends Node2D
class_name WastePile

onready var card_holder : Node = $Cards
onready var tween : Tween = $Tween

signal check_board_state

func _ready() -> void:
	pass

func move_card_to_waste_pile(card, play_tween = true, play_flip = false):
	var parent = card.get_parent()
	parent.remove_child(card)
	card_holder.add_child(card)
	card.set_owner(card_holder)
	card.card_type = "wastepile"
	if play_tween:
		tween.interpolate_property(card, "position", card.position, card_holder.get_parent().position, 1, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		tween.start()
	elif play_flip:
		tween.interpolate_property(card, "position", parent.get_parent().position, card_holder.get_parent().position, 1, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		tween.start()
		#card.position = cardHolder.get_parent().position

	else:
		card.position = card_holder.get_parent().position

	emit_signal("check_board_state")