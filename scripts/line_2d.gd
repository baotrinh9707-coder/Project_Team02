extends Line2D

@onready var launcher = $"../Launcher"
@onready var projectile = $"../Projectile"
@onready var target = $"../Target"

var speed = 585.662
var gravity = -980.0
var angle = -45.0 

func _ready():
	# Gọi hàm tính góc bắn
	angle = calculate_auto_angle()
	
	# Ép góc cho viên đạn
	if projectile != null:
		projectile.angle = angle 
		
	# Vẽ đường bay dự đoán
	draw_trajectory()

func calculate_auto_angle() -> float:
	if target == null or launcher == null:
		return -45.0
		
	var dx = float(target.position.x - launcher.position.x)
	var dy = float(-(target.position.y - launcher.position.y))
	var g_pos = abs(gravity)
	
	# Tránh lỗi chia cho 0 nếu đạn và mục tiêu nằm đè lên nhau
	if dx == 0: dx = 0.001 
	
	var v2 = speed * speed
	var v4 = v2 * v2
	var root = v4 - g_pos * (g_pos * dx * dx + 2.0 * dy * v2)
	
	if root < 0:
		print("❌ Mục tiêu ở quá xa súng! (Ngoài tầm bắn)")
		return -45.0 
		
	var rad = atan((v2 - sqrt(root)) / (g_pos * dx))
	return rad_to_deg(-rad)

func draw_trajectory():
	clear_points()
	var pos0 = launcher.position
	var rad = deg_to_rad(angle)
	var vx = speed * cos(rad)
	var vy = speed * sin(rad)
	
	var t_max = 2.0 * abs(vy / gravity) 
	var step = 0.02 
	
	for i in range(100): 
		var t = i * step
		if t > t_max: break
		
		var x = pos0.x + vx * t
		var y = pos0.y + vy * t - 0.5 * gravity * t * t
		add_point(Vector2(x, y))
		
	width = 3
	default_color = Color(0, 1, 0)
