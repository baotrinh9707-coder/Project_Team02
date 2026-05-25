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
@export var wall_jump_lock_time: float = 0.15

@export var fall_limit_y: float = 700.0

var jumps_left: int = 0
var wall_normal: Vector2 = Vector2.ZERO
var spawn_position: Vector2

var is_wall_jumping: bool = false
var wall_jump_timer: float = 0.0


func _ready() -> void:
	GameManager.player = self
	
	# Khởi tạo lõi quản lý Power-up (nhớ thêm chữ var)
	var decorator_manager = DecoratorManager.new()
	decorator_manager.initialize(self)
	add_child(decorator_manager)


func _process(_delta: float) -> void:
	if global_position.y > fall_limit_y:
		respawn()


func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	wall_normal = Vector2.ZERO
	is_wall_jumping = false
	wall_jump_timer = 0.0
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


func is_holding_toward_wall() -> bool:
	var direction := get_move_axis()

	if wall_normal.x > 0 and direction < 0:
		return true

	if wall_normal.x < 0 and direction > 0:
		return true

	return false


func should_wall_cling() -> bool:
	return is_on_wall() and not is_on_floor() and velocity.y > 0 and is_holding_toward_wall()


func face_toward_wall(animated_sprite_2d: AnimatedSprite2D) -> void:
	if wall_normal.x > 0:
		animated_sprite_2d.flip_h = true
	elif wall_normal.x < 0:
		animated_sprite_2d.flip_h = false


func start_wall_jump() -> void:
	is_wall_jumping = true
	wall_jump_timer = wall_jump_lock_time

	velocity.x = wall_normal.x * wall_jump_x_speed
	velocity.y = -wall_jump_y_speed

	jumps_left = max_jumps - 1


func update_wall_jump_timer(delta: float) -> void:
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	else:
		is_wall_jumping = false
