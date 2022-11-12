extends Node2D
class_name Card

var int_value : int
var suit : String
var face_value : String
var card_front_texture : Texture
var card_back_texture : Texture
var card_type : String

var tableau : Tableau = null

onready var animation : AnimationPlayer = $AnimationPlayer
onready var card_texture_button : TextureButton = $CardButton

func _ready() -> void:
	card_texture_button.texture_normal = card_front_texture
