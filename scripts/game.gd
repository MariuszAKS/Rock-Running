extends Node2D

@onready var player: Player = get_node("Player")

@onready var rock_formation_scene: PackedScene = preload("res://scenes/rock_formation.tscn")
@onready var spawner: Node2D = get_node("Spawner")
@onready var spawn_timer: Timer = spawner.get_node("Timer")
@onready var spawn_area: Area2D = spawner.get_node("Spawn Area")
@onready var remove_area: Area2D = get_node("Remove Area")

@onready var rock_formation_container: Node2D = get_node("Rock Formations")

@onready var game_over_screen: Control = get_node("Game Over Screen")
@onready var score_label: Label = game_over_screen.get_node("CenterContainer/VBoxContainer/Score Label")
@onready var menu_button: Button = game_over_screen.get_node("CenterContainer/VBoxContainer/Menu Button")

var time_temp = 0.2 #0.8
var time_elapsed = 0.0


func _ready() -> void:
	spawn_timer.timeout.connect(spawn_rock_formation)
	spawn_area.body_exited.connect(func(_body): spawn_timer.start(randf_range(0.2, 0.7)))#randf_range(0.2, 0.8)))
	remove_area.body_entered.connect(func(body): body.queue_free())

	player.player_fell.connect(on_player_fell)
	menu_button.pressed.connect(go_to_menu)
	game_over_screen.hide()

	spawn_rock_formation()


func spawn_rock_formation():
	var new_rock_formation = rock_formation_scene.instantiate()

	new_rock_formation.position = spawner.position
	new_rock_formation.set_width(randi_range(50, 250))

	# randomly add obstructions?

	rock_formation_container.add_child(new_rock_formation)


func on_player_fell(time_in_seconds):
	game_over_screen.show()

	if time_in_seconds == 180:
		score_label.text = "You run for 3 minutes straight. Don't waste any more time."
		return
	
	var minutes = floori(time_in_seconds / 60)
	var seconds = floori(time_in_seconds - (minutes * 60))
	var miliseconds = floori(fmod(time_in_seconds, 1) * 100)

	score_label.text = "Run lasted: %s:%s:%s" % ["%02d" % minutes, "%02d" % seconds, "%02d" % miliseconds]


func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
