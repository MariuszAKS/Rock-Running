class_name Player
extends CharacterBody2D

signal player_fell(time)


@onready var animations: AnimatedSprite2D = get_node("Animations")

const RUN_SPEED = 300
const JUMP_VELOCITY = -120
const JUMP_INCREASE = -10
const MAX_JUMP_VELOCITY = -300

var increasing_jump_increase = 0
var jump_pressed_before = false

var time_survived = 0.0


func _physics_process(delta: float) -> void:
	time_survived += delta

	if time_survived >= 180:
		death(180)

	if position.y >= 400:
		death(time_survived)

	handle_jumping(delta)
	handle_animations()


func handle_jumping(delta):
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY

			increasing_jump_increase = 0
			jump_pressed_before = true
	
	elif jump_pressed_before and Input.is_action_pressed("jump"):
		increasing_jump_increase -= 2

		if velocity.y > MAX_JUMP_VELOCITY:
			velocity.y += JUMP_INCREASE + increasing_jump_increase

			if velocity.y <= MAX_JUMP_VELOCITY:
				velocity.y = MAX_JUMP_VELOCITY
				jump_pressed_before = false
	
	else:
		velocity += get_gravity() * delta
		jump_pressed_before = false

	move_and_slide()

func handle_animations():
	if velocity.y == 0:
		animations.play("run")
	elif velocity.y < 0:
		animations.play("jump")
	else:
		animations.play("fall")


func death(time):
	player_fell.emit(time)
	
	queue_free()
