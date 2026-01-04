class_name Breakthrough
extends Node

var board: Array[PackedInt32Array];
var green_pos: PackedVector2Array = [];
var white_pos: PackedVector2Array = [];
var turn: int;

func _init(t: int, gp = null, wp = null, b = null):
	board = b
	turn = t
	
	if gp and wp:
		green_pos = gp
		white_pos = wp
	else:
		for x in b.size():
			for y in b[x].size():
				if b[x][y] == 1:
					green_pos.append(Vector2(x, y))
				elif b[x][y] == 2:
					white_pos.append(Vector2(x, y))


func count_pieces(t: int):
	if t == 0:
		return green_pos.size()
	elif t == 1:
		return white_pos.size()
	return 0

func forward_pieces(t: int):
	var total_sum = 0
	if t == 0:
		for p in green_pos:
			total_sum += int(p.x)
	elif t == 1:
		for p in white_pos:
			total_sum += (7 - int(p.x))
	return total_sum

func is_game_finished():
	var piece_on_base = "none"
	
	for p in green_pos:
		if int(p.x) == 7:
			piece_on_base = "green"
			break
	for p in white_pos:
		if int(p.x) == 7:
			piece_on_base = "white"
			break
			
	if white_pos.size() <= 0 or piece_on_base == "green":
		return 0
	if green_pos.size() <= 0 or piece_on_base == "white":
		return 1
		
	return -1

func wining_score(t: int):
	var win_score = 400
	
	if is_game_finished() == -1:
		return 0
	elif is_game_finished() == t:
		return win_score
	else:
		return -win_score

func my_score(t: int):
	return count_pieces(t) + forward_pieces(t) + wining_score(t)

func get_value(current_player: int):
	return 4 * my_score(current_player) + randi()

func get_actions():
	var available_actions: Array[Action] = [];
	
	var pos_to_use: PackedVector2Array = [];
	
	if turn == 0:
		pos_to_use = green_pos
	elif turn == 1:
		pos_to_use = white_pos
	
	for p in pos_to_use:
		var new_x = int(p.x+(1 - turn * 2))
		for y in [-1, 0, 1]:
			var new_y = int(p.y+y)
			if new_y >= 0 and new_y < board.size():
				var b_pos = board[new_x][new_y]
				if b_pos == 0 or (b_pos != turn+1 and y != 0):
					available_actions.append(Action.new(
						Vector2(new_x, new_y),
						y,
						turn
					))
				
	return available_actions

func move_single_piece(c: Vector2, d: int, t: int):
	var to_move = 1 if t == 0 else -1
	return Vector2(
		c[0] + to_move,
		c[1] + d
	)

func move_piece(action: Action):
	var g_pos := green_pos
	var w_pos := white_pos
	
	if action.turn == 0:
		if action.coord in g_pos:
			var i = g_pos.find(action.coord)
			var new_pos = move_single_piece(action.coord, action.direction, action.turn)
			g_pos[i] = new_pos
			if new_pos in w_pos:
				w_pos.erase(new_pos)
			else:
				print("Action not valid")
			
	
	elif action.turn == 1:
		if action.coord in w_pos:
			var i = w_pos.find(action.coord)
			var new_pos = move_single_piece(action.coord, action.direction, action.turn)
			w_pos[i] = new_pos
			if new_pos in g_pos:
				g_pos.erase(new_pos)
			else:
				print("Action not valid")
	
	var newState = Breakthrough.new(
		1 + (action.turn * -1),
		g_pos, 
		w_pos,
		board,
	)
	return newState
