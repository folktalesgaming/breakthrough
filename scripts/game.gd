extends Node2D

const PIECE = preload("uid://d4cv5cg3gdgpr")

@onready var board: Sprite2D = %Board

const GRID_SIZE := 8
const PIECE_SIZE := 48
var green_positions: Array[Vector2i] = []
var white_positions: Array[Vector2i] = []

func grid_to_word(cell: Vector2i) -> Vector2:
	var board_size := board.get_rect().size
	var cell_size: Vector2 = board_size / GRID_SIZE
	
	return Vector2(
		cell.x * cell_size.x + (cell_size.x - PIECE_SIZE) * 0.5,
		cell.y * cell_size.y + (cell_size.y - PIECE_SIZE) * 0.5
	)

func word_to_grid(pos: Vector2) -> Vector2i:
	var board_size: Vector2 = board.get_rect().size
	var cell_size: Vector2 = board_size/GRID_SIZE
	var local := pos - board.global_position
	
	return Vector2i(
		int(local.x / cell_size.x),
		int(local.y / cell_size.y),
	)

# Function to initiate piece in the given x, y coordinate and the color of piece
func render_piece(x: int, y: int, piece_type: int):
	var new_piece = PIECE.instantiate()
	new_piece.piece_type = piece_type
	var cell := Vector2i(x, y)
	new_piece.position = grid_to_word(cell)
	
	if piece_type == 0:
		green_positions.append(cell)
	else:
		white_positions.append(cell)
	
	board.add_child(new_piece)

func center_board() -> void:
	var viewport_size := get_viewport_rect().size
	var board_size := board.get_rect().size
	
	board.position = (viewport_size - board_size) * 0.5

# READY function
func _ready():
	board.centered = false
	center_board()
	
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			if y == 0 or y == 1:
				render_piece(x, y, 0)
			elif y == GRID_SIZE-2 or y == GRID_SIZE-1:
				render_piece(x, y, 1)
