extends Node2D

# Quit game on quit button pressed
func _on_quit_btn_pressed():
	get_tree().quit()

# Change the scene to settings scene on settings button pressed
func _on_setting_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

# Change the scene to gameplay scene on play button pressed
func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
