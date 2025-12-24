extends Node2D

@onready var piece_sprite = %pieceSprite

enum PIECE_TYPE {
	GREEN,
	WHITE
}

@export var piece_type: PIECE_TYPE = PIECE_TYPE.GREEN

func _ready():
	if piece_type == PIECE_TYPE.GREEN:
		piece_sprite.texture = load("res://assets/green-piece.png")
	if piece_type == PIECE_TYPE.WHITE:
		piece_sprite.texture = load("res://assets/white-piece.png")
