extends Node2D

@onready var board: Sprite2D = %Board
@onready var p_1 = %P1
@onready var p_2 = %P2

const PIECE = preload("uid://d4cv5cg3gdgpr")
const HIGHLIGHT = preload("uid://yw61qt22xri1")
const SELECTED_BORDER = preload("uid://bvko4rgfojd5r")
const DEFAULT_BOARDER = preload("uid://gxjpxo6yqhqt")
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
var green_piece_count = board_matrix.size()*2;
var white_piece_count = board_matrix.size()*2;
var is_game_finished = false;

# get the local position as per the board position
func get_local_pos(cell: Vector2i) -> Vector2:
	var board_size := board.get_rect().size
	var cell_size: Vector2 = board_size / board_matrix.size()
	
	return Vector2(
		cell.x * cell_size.x + (cell_size.x - PIECE_SIZE) * 0.5,
		cell.y * cell_size.y + (cell_size.y - PIECE_SIZE) * 0.5
	)

func get_piece_from_pos(pos: Vector2):
	for piece in board.get_children():
		if piece is Piece:
			if piece.board_pos == pos:
				return piece as Piece

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
	is_game_finished = false
	current_player = 0
	p_1.texture = SELECTED_BORDER
	p_2.texture = DEFAULT_BOARDER
	green_piece_count = board_matrix.size()*2;
	white_piece_count = board_matrix.size()*2;

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
	get_viewport().physics_object_picking_first_only = false
	get_viewport().physics_object_picking_sort = true
	init()
	
	for piece in board.get_children():
		if piece.has_signal("piece_selected"):
			piece.connect("piece_selected", Callable(self, "on_piece_select"))

func remove_highlight():
	for hg in board.get_children():
		if hg.is_in_group("highlight"):
			hg.queue_free()
	
func on_piece_select(piece_node: Piece, pos: Vector2):
	if is_game_finished:
		return
	if selected_piece:
		selected_piece.set_sprite()
	selected_piece = piece_node
	piece_node.set_sprite(true)
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
			var bm_pos = board_matrix[x1][curr_y]
			if bm_pos == 0 or (bm_pos != current_player+1 and y != 0):
				render_highlight(x1, curr_y, pt)

func on_move(new_pos: Vector2):
#	Remove / Capture the opponent piece if the new position has opponent piece
	var new_board_pos_piece = board_matrix[int(new_pos.x)][int(new_pos.y)]
	if new_board_pos_piece != 0 and new_board_pos_piece != current_player+1:
		if current_player == 0:
			white_piece_count -= 1
		elif current_player == 1:
			green_piece_count -= 1
		var captured_piece = get_piece_from_pos(new_pos)
		if captured_piece:
			captured_piece.queue_free()
	
	board_matrix[int(selected_piece.board_pos.x)][int(selected_piece.board_pos.y)] = 0
	selected_piece.position = get_local_pos(new_pos)
	selected_piece.board_pos = new_pos
	selected_piece.set_sprite()
	remove_highlight()
	
	board_matrix[int(new_pos.x)][int(new_pos.y)] = current_player+1
	
	if white_piece_count <= 0 or green_piece_count <= 0:
		is_game_finished = true
		if current_player == 0:
			print("Green player win by all capture")
		elif current_player == 1:
			print("White player win by all capture")
		return
	
	if current_player == 0 and int(new_pos.x) == board_matrix.size()-1:
		is_game_finished = true
		print("Winner green player by base takeover")
		return
	if current_player == 1 and int(new_pos.x) == 0:
		is_game_finished = true
		print("Winner white player by base takeover")
		return
	
	next_player()

func next_player():
	current_player = (current_player+1)%2
	
	if current_player == 0:
		p_1.texture = SELECTED_BORDER
		p_2.texture = DEFAULT_BOARDER
	else:
		p_1.texture = DEFAULT_BOARDER
		p_2.texture = SELECTED_BORDER
