class_name Highlight
extends Area2D

@onready var highlight_sprite = %highlight_sprite

enum PIECE_TYPE {
	GREEN,
	WHITE
}

signal highlight_selected(board_position)

@export var piece_type: PIECE_TYPE = PIECE_TYPE.GREEN
var board_pos := Vector2(0, 0)

func _ready():
	self.input_pickable = true
	if piece_type == PIECE_TYPE.GREEN:
		highlight_sprite.texture = load("res://assets/green-outline.png")
	if piece_type == PIECE_TYPE.WHITE:
		highlight_sprite.texture = load("res://assets/white-outline.png")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		emit_signal("highlight_selected", board_pos)
