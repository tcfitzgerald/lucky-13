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
onready var ui = $UI

onready var hint_line = $HintLine
onready var hint_timer = $HintTimer

var card_offset : int = 50
var start_card_offset : int = 150
var tableau_count : int = 5
var overflow_tableau_count : int = 2
var cards_per_tableau : int = 1

var available_moves : Array = []
var playable_cards : Array = []

class CardSort:
	static func sort_descending(a, b):
		if a.priority > b.priority:
			return true
		return false

func _ready() -> void:
	
	ui.connect("hint_button_pressed", self, "hint")
	ui.connect("undo_button_pressed", self, "undo")
	
	deck.build_deck()
	deal()
	deck.connect("deck_clicked", self, "deal")
	waste_pile.connect("check_board_state", self, "_on_check_board_state")
	for tableau in tableaus:
		tableau.connect("card_added", self, "update_deck")
		tableau.connect("check_board_state", self, "_on_check_board_state")
		
	for tableau in overflow_tableaus:
		tableau.connect("card_added", self, "update_deck")

# warning-ignore:unused_argument
func _unhandled_key_input(event) -> void:
	if Input.is_action_just_pressed("reload"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("matches"):
# warning-ignore:return_value_discarded
		board_has_matches()
	
	if Input.is_action_just_pressed("undo"):
		undo()


func deal() -> void:
	
	var duration = 1
	var _moves = []
	
	if BoardManager.is_card_selected:
		deck.animation.play("Shake")
		return

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
			

	for tableau in tableaus:
		if !tableau.has_cards():
			_card_matches.append([tableau])
	
	for card in _tableau_cards:
		for i in _tableau_cards.size():
			if card != _tableau_cards[i]:
				
				if card.int_value + _tableau_cards[i].int_value == 13:
					_card_matches.append([card, _tableau_cards[i]])
					
				if card.int_value == 13:
					_card_matches.append([card])

	return bool(_card_matches.size() > 0)

func get_board_matches() -> Array:
	 
	var _tableau_cards : Array
	var _card_matches : Array
	
	for tableau in tableaus:
		if tableau.has_cards():
			_tableau_cards.append(tableau.get_top_tableau_card())
	
	for overflow_tableau in overflow_tableaus:
		if overflow_tableau.has_cards():
			_tableau_cards.append(overflow_tableau.get_top_tableau_card())
	
	
	for card in _tableau_cards:
		for i in _tableau_cards.size():
			if card != _tableau_cards[i]:
				
				if card.int_value + _tableau_cards[i].int_value == 13:
					_card_matches.append([card, _tableau_cards[i]])
					
				if card.int_value == 13:
					_card_matches.append([card])
					break
					
	for tableau in tableaus:
		if !tableau.has_cards():
			_tableau_cards.sort_custom(CardSort, "sort_descending")
			var random_tableau_card = _tableau_cards.pop_front()
			_card_matches.append([random_tableau_card, tableau])

	return _card_matches

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
	if !tableaus_have_cards() and deck.get_card_count() == 0:
		gameover("win")
		
	if deck.get_card_count() == 0 and !board_has_matches():
		gameover("lose")

func undo():
	if BoardManager.moves.size() > 0:
		var moves = BoardManager.moves.back()
		moves.invert()
		for move in moves:
			var parent = move.card_parent
			var card = move.card_node
			var card_position = move.current_position
			var card_data = move.card_data
# warning-ignore:unused_variable
			var undo_move = card_move.new(card, card.to_json(), parent, card_position, "undo")
			card.get_parent().remove_child(card)
			parent.add_child(card)
			card.set_owner(parent)
			card.card_type = card_data['card_type']
			card.tableau = card_data['tableau']
			card.priority = card_data['priority']
			undo_tween.interpolate_property(card, "position", card.position, 
				Vector2(card_position.x, card_position.y), 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			undo_tween.start()
		BoardManager.moves.pop_back()
		update_deck()

	else:
		return


func hint() -> void:
	var cards = get_board_matches()

	if cards:

		var card_set = cards.pop_front()
		print(card_set)
		if card_set.size() > 1:
			if card_set[1].priority != 0 and card_set[0].priority != 1:
				hint_line.add_point(Vector2(card_set[0].position.x + 70, card_set[0].position.y + 70))
				hint_line.add_point(Vector2(card_set[1].position.x + 70, card_set[1].position.y + 70))
				hint_timer.start()
				
			if card_set[1].priority == 0 and card_set[0].priority > 1:
				hint_line.add_point(Vector2(card_set[0].position.x + 70, card_set[0].position.y + 70))
				hint_line.add_point(Vector2(card_set[1].position.x + 70, card_set[1].position.y + 70))
				hint_timer.start()
				
			if card_set[1].priority == 1 and card_set[0].priority == 1:
				hint_line.add_point(Vector2(card_set[0].position.x + 70, card_set[0].position.y + 70))
				hint_line.add_point(Vector2(card_set[1].position.x + 70, card_set[1].position.y + 70))
				hint_timer.start()
				
			if (card_set[1].priority == 1 and card_set[0].priority > 1) or (card_set[1].priority > 1 and card_set[0].priority == 1):
				hint_line.add_point(Vector2(card_set[0].position.x + 70, card_set[0].position.y + 70))
				hint_line.add_point(Vector2(card_set[1].position.x + 70, card_set[1].position.y + 70))
				hint_timer.start()
		
		if card_set.size() == 1:
			hint_line.add_point(Vector2(card_set[0].position.x + 70, card_set[0].position.y + 70))
			hint_line.add_point(Vector2(waste_pile.position.x + 70, waste_pile.position.y + 70))
			hint_timer.start()

	
#	for card in cards:
#		card.front().animation.play("CardShake")
#		card.back().animation.play("CardShake")

func win() -> void:
	print("win")
	return
	
func lose() -> void:
	print("lose")
	return
	
func gameover(status : String):
	match status:
		"win":
			win()
		"lose":
			lose()
	


func _on_HintTimer_timeout() -> void:
	hint_line.clear_points()
