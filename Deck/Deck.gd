extends Node2D
class_name Deck

onready var card_holder: Node2D = $Cards
onready var card_button: TextureButton = $CardTexture
onready var animation : AnimationPlayer = $AnimationPlayer

signal deck_clicked
# preload
const card_scene: PackedScene = preload("res://Card/Card.tscn")


var cards: Array = [
{"int_value": 13, "suit": "Spades", "face": "King", "texture": "cardSpadesK.png"},
{"int_value": 12, "suit": "Spades", "face": "Queen", "texture": "cardSpadesQ.png"},
{"int_value": 11, "suit": "Spades", "face": "Jack", "texture": "cardSpadesJ.png"},
{"int_value": 10, "suit": "Spades", "face": "Ten", "texture": "cardSpades10.png"},
{"int_value": 9, "suit": "Spades", "face": "Nine", "texture": "cardSpades9.png"},
{"int_value": 8, "suit": "Spades", "face": "Eight", "texture": "cardSpades8.png"},
{"int_value": 7, "suit": "Spades", "face": "Seven", "texture": "cardSpades7.png"},
{"int_value": 6, "suit": "Spades", "face": "Six", "texture": "cardSpades6.png"},
{"int_value": 5, "suit": "Spades", "face": "Five", "texture": "cardSpades5.png"},
{"int_value": 4, "suit": "Spades", "face": "Four", "texture": "cardSpades4.png"},
{"int_value": 3, "suit": "Spades", "face": "Three", "texture": "cardSpades3.png"},
{"int_value": 2, "suit": "Spades", "face": "Two", "texture": "cardSpades2.png"},
{"int_value": 1, "suit": "Spades", "face": "Ace", "texture": "cardSpadesA.png"},
{"int_value": 13, "suit": "Hearts", "face": "King", "texture": "cardHeartsK.png"},
{"int_value": 12, "suit": "Hearts", "face": "Queen", "texture": "cardHeartsQ.png"},
{"int_value": 11, "suit": "Hearts", "face": "Jack", "texture": "cardHeartsJ.png"},
{"int_value": 10, "suit": "Hearts", "face": "Ten", "texture": "cardHearts10.png"},
{"int_value": 9, "suit": "Hearts", "face": "Nine", "texture": "cardHearts9.png"},
{"int_value": 8, "suit": "Hearts", "face": "Eight", "texture": "cardHearts8.png"},
{"int_value": 7, "suit": "Hearts", "face": "Seven", "texture": "cardHearts7.png"},
{"int_value": 6, "suit": "Hearts", "face": "Six", "texture": "cardHearts6.png"},
{"int_value": 5, "suit": "Hearts", "face": "Five", "texture": "cardHearts5.png"},
{"int_value": 4, "suit": "Hearts", "face": "Four", "texture": "cardHearts4.png"},
{"int_value": 3, "suit": "Hearts", "face": "Three", "texture": "cardHearts3.png"},
{"int_value": 2, "suit": "Hearts", "face": "Two", "texture": "cardHearts2.png"},
{"int_value": 1, "suit": "Hearts", "face": "Ace", "texture": "cardHeartsA.png"},
{"int_value": 13, "suit": "Diamonds", "face": "King", "texture": "cardDiamondsK.png"},
{"int_value": 12, "suit": "Diamonds", "face": "Queen", "texture": "cardDiamondsQ.png"},
{"int_value": 11, "suit": "Diamonds", "face": "Jack", "texture": "cardDiamondsJ.png"},
{"int_value": 10, "suit": "Diamonds", "face": "Ten", "texture": "cardDiamonds10.png"},
{"int_value": 9, "suit": "Diamonds", "face": "Nine", "texture": "cardDiamonds9.png"},
{"int_value": 8, "suit": "Diamonds", "face": "Eight", "texture": "cardDiamonds8.png"},
{"int_value": 7, "suit": "Diamonds", "face": "Seven", "texture": "cardDiamonds7.png"},
{"int_value": 6, "suit": "Diamonds", "face": "Six", "texture": "cardDiamonds6.png"},
{"int_value": 5, "suit": "Diamonds", "face": "Five", "texture": "cardDiamonds5.png"},
{"int_value": 4, "suit": "Diamonds", "face": "Four", "texture": "cardDiamonds4.png"},
{"int_value": 3, "suit": "Diamonds", "face": "Three", "texture": "cardDiamonds3.png"},
{"int_value": 2, "suit": "Diamonds", "face": "Two", "texture": "cardDiamonds2.png"},
{"int_value": 1, "suit": "Diamonds", "face": "Ace", "texture": "cardDiamondsA.png"},
{"int_value": 13, "suit": "Clubs", "face": "King", "texture": "cardClubsK.png"},
{"int_value": 12, "suit": "Clubs", "face": "Queen", "texture": "cardClubsQ.png"},
{"int_value": 11, "suit": "Clubs", "face": "Jack", "texture": "cardClubsJ.png"},
{"int_value": 10, "suit": "Clubs", "face": "Ten", "texture": "cardClubs10.png"},
{"int_value": 9, "suit": "Clubs", "face": "Nine", "texture": "cardClubs9.png"},
{"int_value": 8, "suit": "Clubs", "face": "Eight", "texture": "cardClubs8.png"},
{"int_value": 7, "suit": "Clubs", "face": "Seven", "texture": "cardClubs7.png"},
{"int_value": 6, "suit": "Clubs", "face": "Six", "texture": "cardClubs6.png"},
{"int_value": 5, "suit": "Clubs", "face": "Five", "texture": "cardClubs5.png"},
{"int_value": 4, "suit": "Clubs", "face": "Four", "texture": "cardClubs4.png"},
{"int_value": 3, "suit": "Clubs", "face": "Three", "texture": "cardClubs3.png"},
{"int_value": 2, "suit": "Clubs", "face": "Two", "texture": "cardClubs2.png"},
{"int_value": 1, "suit": "Clubs", "face": "Ace", "texture": "cardClubsA.png"}

]


func _ready() -> void:
	pass

func build_deck() -> void:
	randomize()
	var _seed = randi()
	seed(_seed)
	print(_seed)
	BoardManager._seed = _seed
	cards.shuffle()
	cards.invert()
	for card in cards:
		var new_card = card_scene.instance()
		new_card.suit = card["suit"]
		new_card.int_value = card["int_value"]
		new_card.face_value = card["face"]
		new_card.card_front_texture = load("res://Card/Images/" + card["texture"])
		card_holder.add_child(new_card)

func get_top_card() -> Node:
	var cards_count = card_holder.get_child_count()
	var top_card = card_holder.get_child(cards_count - 1)
	
	return top_card

func get_card_count() -> int:
	return card_holder.get_child_count()

func update_display(state) -> void:
	if state == 'hide':
		card_button.disabled = true
		card_button.visible = false
	elif state == 'show':
		card_button.disabled = false
		card_button.visible = true

func _on_CardTexture_pressed() -> void:
	emit_signal("deck_clicked")
