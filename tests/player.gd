class_name Player
extends CharacterBody2D

var player_direction: Vector2 = Vector2.RIGHT

@export var move_speed: float = 80.0
@export var air_speed: float = 80.0
@export var jump_speed: float = 320.0
@export var gravity: float = 700.0
@export var max_jumps: int = 2

@export var wall_slide_speed: float = 45.0
@export var wall_jump_x_speed: float = 180.0
@export var wall_jump_y_speed: float = 320.0

@export var fall_limit_y: float = 700.0

var jumps_left: int = 0
var wall_normal: Vector2 = Vector2.ZERO
var spawn_position: Vector2


func _ready() -> void:
	spawn_position = global_position
	reset_jumps()


func _process(_delta: float) -> void:
	if global_position.y > fall_limit_y:
		respawn()


func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	wall_normal = Vector2.ZERO
	reset_jumps()

	var state_machine = get_node_or_null("States")
	if state_machine != null:
		state_machine.transition_to("Idle")


func reset_jumps() -> void:
	jumps_left = max_jumps


func perform_jump() -> void:
	if jumps_left <= 0:
		return

	velocity.y = -jump_speed
	jumps_left -= 1


func can_jump() -> bool:
	return jumps_left > 0


func get_move_axis() -> float:
	return Input.get_axis("walk_left", "walk_right")


func update_wall_normal() -> void:
	if is_on_wall():
		wall_normal = get_wall_normal()
	else:
		wall_normal = Vector2.ZERO
