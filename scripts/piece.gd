class_name Piece
extends Area2D

@onready var piece_sprite = %pieceSprite

enum PIECE_TYPE {
	GREEN,
	WHITE
}

signal piece_selected(piece_node, board_position)

@export var piece_type: PIECE_TYPE = PIECE_TYPE.GREEN
var board_pos := Vector2(0, 0)

func set_sprite(is_selected: bool = false):
	if is_selected:
		if piece_type == PIECE_TYPE.GREEN:
			piece_sprite.texture = load("res://assets/green_gloss.png")
		if piece_type == PIECE_TYPE.WHITE:
			piece_sprite.texture = load("res://assets/white_gloss.png")
	else:
		if piece_type == PIECE_TYPE.GREEN:
			piece_sprite.texture = load("res://assets/green_flat.png")
		if piece_type == PIECE_TYPE.WHITE:
			piece_sprite.texture = load("res://assets/white_flat.png")

func _ready():
	self.input_pickable = true
	set_sprite()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		emit_signal("piece_selected", self, board_pos)
