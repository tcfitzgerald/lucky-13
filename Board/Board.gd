extends Control
class_name Board

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

var card_offset: int = 50
var tableau_count: int = 5
var overflow_tableau_count: int = 2
var cards_per_tableau: int = 1

var available_moves: Array = []
var playable_cards: Array = []



func _ready() -> void:
	deck.build_deck()
	deal()
	deck.connect("deck_clicked", self, "deal")
	for tableau in tableaus:
		tableau.connect("card_added", self, "update_deck")
		
	for tableau in overflow_tableaus:
		tableau.connect("card_added", self, "update_deck")

func deal() -> void:
	
	var duration = 1

	if deck.get_card_count() > 7:
	
		for i in range(0, cards_per_tableau):
			for j in range(0, tableau_count):
				var selected_card = deck.get_top_card()
				deck_cards.remove_child(selected_card)
				var k = tableaus[j].get_card_count()
				duration += .5
				tableaus[j].add_card_to_tableau(selected_card, k * card_offset, duration * .35)
	else:
		for i in range(0, cards_per_tableau):
			for j in range(0, tableau_count):
				var selected_card = deck.get_top_card()
				deck_cards.remove_child(selected_card)
				var k = tableaus[j].get_card_count()
				duration += .5
				tableaus[j].add_card_to_tableau(selected_card, k * card_offset, duration * .35)
				
		for i in range(0, cards_per_tableau):
			for j in range(0, overflow_tableau_count):
				var selected_card = deck.get_top_card()
				deck_cards.remove_child(selected_card)
				duration += .5
				overflow_tableaus[j].add_card_to_tableau(selected_card, i * card_offset, duration * .35)

func update_deck() -> void:
	if deck.get_card_count() == 0:
		deck.update_display()
