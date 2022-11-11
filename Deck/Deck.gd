extends Node2D
class_name Deck

onready var card_holder = $Cards

# preload
var card_scene: PackedScene = preload("res://Card/Card.tscn")

func _ready() -> void:
	pass
