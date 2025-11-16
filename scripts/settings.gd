extends Node2D

# Go back to menu scene on back button pressed
func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
