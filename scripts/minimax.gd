class_name Minimax
extends Node

var board: Array[PackedInt32Array]
var turn: int;
var max_depth: int;

func _init(b: Array[PackedInt32Array], t: int, depth: int = 3):
	board = b
	turn = t
	max_depth = depth

func maximizer(state: Breakthrough, d: int):
	if d == max_depth or state.is_game_finished() != -1:
		return state.get_value(turn)
	var value = -INF
	for action in state.get_actions():
		value = max(value, minimizer(state.move_piece(action), d+1))
	return value

func minimizer(state: Breakthrough, d: int):
	if d == max_depth or state.is_game_finished() != -1:
		return state.get_value(turn)
	var value = -INF
	for action in state.get_actions():
		value = min(value, maximizer(state.move_piece(action), d+1))
	return value

func minimax_search():
	var action_to_perform: Action = null;
	
	var currentState = Breakthrough.new(
		turn,
		null,
		null,
		board
	)
	
	var value = -INF
	for action in currentState.get_actions():
		var ahead_state = currentState.move_piece(action)
		if ahead_state.is_game_finished() != -1:
			action_to_perform = action
			break
		var min_result = minimizer(ahead_state, 1)
		if min_result > value:
			action_to_perform = action
			value = min_result
	
	return action_to_perform.coord
