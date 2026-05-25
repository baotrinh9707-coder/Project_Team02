extends Node2D

@onready var sprite = $Sprite2D
@onready var line = $"../Line2D"
@onready var launcher = $"../Launcher"
@onready var target = $"../Target"

var velocity = Vector2.ZERO
var gravity = -980.0
var speed = 585.662
var angle = -45.0
var is_flying = false
var step_time = 0.02
var update_time = 0.0

func launch():
	if is_flying: return
	is_flying = true
	position = launcher.position
	var rad = deg_to_rad(angle)
	velocity.x = speed * cos(rad)
	velocity.y = speed * sin(rad)
	line.draw_trajectory()

func _process(delta):
	if not is_flying: return
	
	update_time += delta
	while update_time >= step_time:
		update_time -= step_time
		
		# --- PHẦN BÀI TẬP TODO ĐÃ ĐƯỢC GIẢI ---
		# 1. Cập nhật vận tốc (gia tốc rơi tự do) và vị trí
		velocity.y -= gravity * step_time
		position += velocity * step_time
		
		# 2 & 3. Kiểm tra chạm đất (y > 300) thì reset đạn
		if position.y > 300:
			update_time = 0
			is_flying = false
			position = launcher.position
			break
