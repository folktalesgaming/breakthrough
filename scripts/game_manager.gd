extends Node2D

@onready var board: Sprite2D = %Board

const PIECE = preload("uid://d4cv5cg3gdgpr")
const HIGHLIGHT = preload("uid://yw61qt22xri1")
const PIECE_SIZE := 48

var board_matrix = [
	[1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0],
	[2, 2, 2, 2, 2, 2, 2, 2],
	[2, 2, 2, 2, 2, 2, 2, 2],
];
var current_player = 0;
var is_game_paused = false;
var is_choosing = false;
var selected_piece: Piece;

# get the local position as per the board position
func get_local_pos(cell: Vector2i) -> Vector2:
	var board_size := board.get_rect().size
	var cell_size: Vector2 = board_size / board_matrix.size()
	
	return Vector2(
		cell.x * cell_size.x + (cell_size.x - PIECE_SIZE) * 0.5,
		cell.y * cell_size.y + (cell_size.y - PIECE_SIZE) * 0.5
	)

#func get_world_pos(pos: Vector2) -> Vector2i:
	#var board_size: Vector2 = board.get_rect().size
	#var cell_size: Vector2 = board_size/GRID_SIZE
	#var local := pos - board.global_position
	#
	#return Vector2i(
		#int(local.x / cell_size.x),
		#int(local.y / cell_size.y),
	#)

# Function to render pieces in correct x, y position
func render_piece(x: int, y: int, piece_type: int):
	var new_piece = PIECE.instantiate()
	new_piece.piece_type = piece_type
	var cell := Vector2i(x, y)
	new_piece.position = get_local_pos(cell)
	new_piece.board_pos = cell
	
	board.add_child(new_piece)

# Function to center the board
func center_board() -> void:
	var viewport_size := get_viewport_rect().size
	var board_size := board.get_rect().size
	
	board.position = (viewport_size - board_size) * 0.5

# Function to initialize the game
func init():
	current_player = 0
	board.centered = false
	center_board()
	
	for x in board_matrix.size():
		for y in board_matrix[x].size():
			if board_matrix[x][y] == 1:
				render_piece(x, y, 0)
			elif board_matrix[x][y] == 2:
				render_piece(x, y, 1)

func render_highlight(x: int, y: int, piece_type: int):
	var high_light = HIGHLIGHT.instantiate()
	high_light.piece_type = piece_type
	var cell := Vector2i(x, y)
	high_light.position = get_local_pos(cell)
	high_light.board_pos = cell
	
	high_light.connect("highlight_selected", Callable(self, "on_move"))
	
	board.add_child(high_light)

func _ready():
	init()
	
	for piece in board.get_children():
		if piece.has_signal("piece_selected"):
			piece.connect("piece_selected", Callable(self, "on_piece_select"))

func remove_highlight():
	for hg in board.get_children():
		if hg.is_in_group("highlight"):
			hg.queue_free()
	
func on_piece_select(piece_node: Piece, pos: Vector2):
	selected_piece = piece_node
	remove_highlight()
	
	if current_player != piece_node.piece_type:
		return
	
	var pt = piece_node.piece_type
	var x1 = 0
	if pt == 0:
		x1 = int(pos.x+1)
	elif pt == 1:
		x1 = int(pos.x-1)
	
	for y in [-1,0,1]:
		var curr_y = int(pos.y+y)
		if curr_y >= 0 and curr_y < board_matrix.size():
			if board_matrix[x1][curr_y] != current_player+1:
				render_highlight(x1, curr_y, pt)

func on_move(new_pos: Vector2):
	board_matrix[int(selected_piece.board_pos.x)][int(selected_piece.board_pos.y)] = 0
	board_matrix[int(new_pos.x)][int(new_pos.y)] = current_player+1
	selected_piece.position = get_local_pos(new_pos)
	selected_piece.board_pos = new_pos
	remove_highlight()
	
	current_player = (current_player+1)%2
