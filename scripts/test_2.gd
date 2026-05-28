extends Node2D

@onready var proj = $Projectile

func _input(event):
	# Nhấn phím Space hoặc Enter để bắn
	if event.is_action_pressed("ui_accept"): 
		proj.launch()
