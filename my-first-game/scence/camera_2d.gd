extends Camera2D



@export var level_1_camera_y: float = -1600
@export var level_2_camera_y: float = -960 
@export var level_3_camera_y: float = -320
@export var level_4_camera_y: float = 320
@export var level_5_camera_y: float = 960
@export var level_6_camera_y: float = 1600
@export var level_7_camera_y: float = 2240


@export var camera_speed: float = 1200.0

var current_level := 1


# Called when the node enters the scene tree for the first time.


func _ready() -> void:

	global_position.y  = level_1_camera_y 
	pass 


func _process(_delta: float) -> void:
	
	var player = get_parent()
	global_position.x = player.global_position.x 
	
	
	if player.global_position.y < -1821:
		current_level = 1

	elif player.global_position.y < -1181 and player.global_position.y > -1669:
		current_level = 2
		
	elif player.global_position.y < -541 and player.global_position.y > -1181:
		current_level = 3
		
		## diff off ___ and -154 
		
	elif player.global_position.y < 98 and player.global_position.y > -541:
		current_level = 4
		
	elif player.global_position.y < 738 and player.global_position.y > 98:
		current_level = 5
		
	elif player.global_position.y < 1378 and player.global_position.y > 738:
		current_level = 6
	
	elif player.global_position.y < 2019 and player.global_position.y > 1378:
		current_level = 7
		
		
		
		
		
		


	else:
		pass
		
	var target_y: float
	

	if current_level == 1:
		target_y = level_1_camera_y
	if current_level == 2:
		target_y = level_2_camera_y
	if current_level == 3:
		target_y = level_3_camera_y 
	if current_level == 4:
		target_y = level_4_camera_y 
	if current_level == 5:
		target_y = level_5_camera_y 
	if current_level == 6:
		target_y = level_6_camera_y
	if current_level == 7:
		target_y = level_7_camera_y 

		

		
	global_position.y = move_toward(global_position.y, target_y, camera_speed)
		
		

	#if current_level == 1 and player.global_position.y >= 640.0:
		#current_level = 2 
		#global_position.y = level_2_camera_y 	
		
