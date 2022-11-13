extends Control
class_name Board

const card_move = preload("res://Card/Move.gd")

onready var deck = $MarginContainer/CenterContainer/Deck
onready var deck_cards = $MarginContainer/CenterContainer/Deck/Cards

onready var tableau1 = $MarginContainer/CenterContainer/Tableau1
onready var tableau2 = $MarginContainer/CenterContainer/Tableau2
onready var tableau3 = $MarginContainer/CenterContainer/Tableau3
onready var tableau4 = $MarginContainer/CenterContainer/Tableau4
onready var tableau5 = $MarginContainer/CenterContainer/Tableau5

onready var tableau6 = $MarginContainer/CenterContainer/Tableau6
onready var tableau7 = $MarginContainer/CenterContainer/Tableau7

onready var tableaus = [tableau1, tableau2, tableau3, tableau4, tableau5]
onready var overflow_tableaus = [tableau6, tableau7]

onready var waste_pile = $MarginContainer/CenterContainer/WastePile

onready var undo_tween = $Tween

var card_offset : int = 50
var start_card_offset : int = 150
var tableau_count : int = 5
var overflow_tableau_count : int = 2
var cards_per_tableau : int = 1

var available_moves : Array = []
var playable_cards : Array = []

func _ready() -> void:
	deck.build_deck()
	deal()
	deck.connect("deck_clicked", self, "deal")
	waste_pile.connect("check_board_state", self, "_on_check_board_state")
	for tableau in tableaus:
		tableau.connect("card_added", self, "update_deck")
		
	for tableau in overflow_tableaus:
		tableau.connect("card_added", self, "update_deck")

# warning-ignore:unused_argument
func _unhandled_key_input(event) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("matches"):
# warning-ignore:return_value_discarded
		board_has_matches()
	
	if Input.is_action_just_pressed("undo"):
		undo()


func deal() -> void:
	
	var duration = 1
	var _moves = []

	if deck.get_card_count() > 7:
	
# warning-ignore:unused_variable
		for i in range(0, cards_per_tableau):
			for j in range(0, tableau_count):
				var selected_card = deck.get_top_card()
				var move = card_move.new(selected_card, selected_card.to_json(), selected_card.get_parent(), selected_card.position, "deal")
				_moves.append(move)
				selected_card.card_type = "tableau"
				deck_cards.remove_child(selected_card)
				var k = tableaus[j].get_card_count()
				duration += .5
				tableaus[j].add_card_to_tableau(selected_card, k * card_offset, start_card_offset, duration * .35)

		BoardManager.moves.append(_moves)
	else:
# warning-ignore:unused_variable
		for i in range(0, cards_per_tableau):
			for j in range(0, tableau_count):
				var selected_card = deck.get_top_card()
				var move = card_move.new(selected_card, selected_card.to_json(), selected_card.get_parent(), selected_card.position, "deal")
				_moves.append(move)
				selected_card.card_type = "tableau"
				deck_cards.remove_child(selected_card)
				var k = tableaus[j].get_card_count()
				duration += .5
				tableaus[j].add_card_to_tableau(selected_card, k * card_offset, start_card_offset, duration * .35)


				
		for i in range(0, cards_per_tableau):
			for j in range(0, overflow_tableau_count):
				var selected_card = deck.get_top_card()
				var move = card_move.new(selected_card, selected_card.to_json(), selected_card.get_parent(), selected_card.position, "deal")
				_moves.append(move)
				selected_card.card_type = "tableau"
				deck_cards.remove_child(selected_card)
				duration += .5
				overflow_tableaus[j].add_card_to_tableau(selected_card, i * card_offset, start_card_offset, duration * .35)

		
		BoardManager.moves.append(_moves)
	_on_check_board_state()

func update_deck() -> void:
	if deck.get_card_count() == 0:
		deck.update_display('hide')
	else:
		deck.update_display('show')


func get_playable_cards() -> Array:
	var _playable_cards = []
	
	for tableau in tableaus:
		if tableau.has_cards():
			_playable_cards.append(tableau.get_top_tableau_card())
		
	for overflow_tableau in overflow_tableaus:
		if overflow_tableau.has_cards():
			_playable_cards.append(overflow_tableau.get_top_tableau_card())

	return _playable_cards

func get_available_moves_for_card(card) -> Array:
	var _playable_cards = get_playable_cards()
	var _available_moves = []
	var selected_card = _playable_cards.find(card)
	
	if selected_card != -1:
		_playable_cards.remove(selected_card)
	
	for playable_card in _playable_cards:
		if card.int_value + playable_card.int_value == 13 \
		or card.int_value == 13:
			_available_moves.append(playable_card)
			
	for tableau in tableaus:
		if !tableau.has_cards():
			_available_moves.append(tableau)
	
	#print(_available_moves)
	
	return _available_moves


func board_has_matches() -> bool:
	 
	var _tableau_cards : Array
	var _card_matches : Array
	
	for tableau in tableaus:
		if tableau.has_cards():
			_tableau_cards.append(tableau.get_top_tableau_card())
	
	for overflow_tableau in overflow_tableaus:
		if overflow_tableau.has_cards():
			_tableau_cards.append(overflow_tableau.get_top_tableau_card())
			
	var matches = 0
	
	for tableau in tableaus:
		if !tableau.has_cards():
			_card_matches.append([tableau])
	
	for card in _tableau_cards:
		for i in _tableau_cards.size():
			if card != _tableau_cards[i]:
				#print("Card value: ", card.int_value, "Tableau Card: ", _tableau_cards[i].int_value)
				if card.int_value + _tableau_cards[i].int_value == 13 or card.int_value == 13:

					matches += 1
					_card_matches.append([card, _tableau_cards[0]])
	print(_card_matches.size())
	return bool(_card_matches.size() > 0)

func tableaus_have_cards() -> bool:
	var _tableau_cards = []
	
	for tableau in tableaus:
		if tableau.has_cards():
			_tableau_cards.append(tableau.get_top_tableau_card())
			
	for overflow_tableau in overflow_tableaus:
		if overflow_tableau.has_cards():
			_tableau_cards.append(overflow_tableau.get_top_tableau_card())
			
	return _tableau_cards.size() > 0

func _on_check_board_state() -> void:
	print("check board state")
	if !tableaus_have_cards() and deck.get_card_count() == 0:
		print(" win ")
		
	if deck.get_card_count() == 0 and !board_has_matches():
		print("lose")

func undo():
	if BoardManager.moves.size() > 0:
		var moves = BoardManager.moves.back()
		moves.invert()
		for move in moves:
			var parent = move.card_parent
			var card = move.card_node
			var card_position = move.current_position
			var card_data = move.card_data
			var undo_move = card_move.new(card, card.to_json(), parent, card_position, "undo")
			card.get_parent().remove_child(card)
			parent.add_child(card)
			card.set_owner(parent)
			#print(card_data)
			card.card_type = card_data['card_type']
			card.tableau = card_data['tableau']
			#card.position = cardPosition
			undo_tween.interpolate_property(card, "position", card.position, 
				Vector2(card_position.x, card_position.y), 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			undo_tween.start()
		BoardManager.moves.pop_back()
		update_deck()

	else:
		return
