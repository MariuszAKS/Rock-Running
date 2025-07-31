class_name RockFormation
extends AnimatableBody2D


const MOVE_SPEED = 300


func _process(delta: float) -> void:
	move_and_collide(Vector2.LEFT * MOVE_SPEED * delta)


func set_width(width: float):
	var collision_shape = get_node("Collision")
	var color_rect = get_node("ColorRect")

	collision_shape.position.x = width / 2
	(collision_shape.shape as RectangleShape2D).size.x = width
	color_rect.size.x = width
