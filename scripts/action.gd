class_name Action
extends Node

var coord: Vector2;
var direction: int;
var turn: int;

func _init(c: Vector2, d: int, t: int):
	coord = c
	direction = d
	turn = t
