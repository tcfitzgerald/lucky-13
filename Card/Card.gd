extends Node2D
class_name Card

const card_move = preload("res://Card/Move.gd")

var int_value : int
var suit : String
var face_value : String
var card_front_texture : Texture
var card_back_texture : Texture
var card_type : String

var tableau : Tableau = null
var selected : bool = false

onready var board = get_tree().root.get_node("Board")
onready var waste_pile : WastePile = board.waste_pile
onready var animation : AnimationPlayer = $AnimationPlayer
onready var card_texture_button : TextureButton = $CardButton

func _ready() -> void:
	card_texture_button.texture_normal = card_front_texture


func _on_CardButton_pressed() -> void:

	if card_type == "tableau":
		if !tableau.is_top_tableau_card(self):
			return

	var available_moves : Array = board.get_available_moves_for_card(self)
	
	if BoardManager.is_card_selected == false && len(available_moves) > 0:
		
		if card_type == "tableau":
			modulate = Color(.88, .90, .63)
			selected = true
			BoardManager.is_card_selected = true
			BoardManager.selected_card = self

			animation.play("CardScale")
			
			if (int_value == 13):
				animation.play_backwards("CardScale")
				selected = false
				modulate = Color.white
				var move = card_move.new(self, self.to_json(), get_parent(), position, "play")
				BoardManager.moves.append([move])
				card_type = "wastepile"
				waste_pile.move_cards_to_waste_pile([BoardManager.selected_card])
				
				BoardManager.selected_card = null
				BoardManager.is_card_selected = false
			
				return
		else:
			animation.play("CardShake")
		
		if selected == false:
			animation.play("CardShake")

	elif BoardManager.is_card_selected == true:
			
		if BoardManager.selected_card == self:
			animation.play_backwards("CardScale")

			BoardManager.selected_card = null
			BoardManager.is_card_selected = false

			selected = false
			modulate = Color.white
			return

		if (BoardManager.selected_card.int_value + int_value == 13) \
			and BoardManager.selected_card != self:
			animation.play_backwards("CardScale")
			selected = false
			modulate = Color.white
			BoardManager.selected_card.selected = false
			BoardManager.selected_card.modulate = Color.white
			BoardManager.selected_card.animation.play_backwards("CardScale")
			var move1 = card_move.new(BoardManager.selected_card, BoardManager.selected_card.to_json(), BoardManager.selected_card.get_parent(), BoardManager.selected_card.position, "play")
			var move2 = card_move.new(self, self.to_json(), get_parent(), position, "play")
			BoardManager.moves.append([move1, move2])
			BoardManager.selected_card.card_type = "wastepile"
			card_type = "wastepile"
			waste_pile.move_cards_to_waste_pile([self, BoardManager.selected_card])


			BoardManager.selected_card = null
			BoardManager.is_card_selected = false

		else:
			animation.play("CardShake")
	else:
		animation.play("CardShake")

func to_json():
	return {"int_value": int_value, "suit": suit, "face": face_value, "card_type": card_type, "tableau": tableau}
