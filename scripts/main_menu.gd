extends Control


@export var start_button: Button
@export var exit_button: Button


func _ready():
	start_button.pressed.connect(start_game)
	exit_button.pressed.connect(exit_game)


func start_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func exit_game():
	get_tree().quit()
