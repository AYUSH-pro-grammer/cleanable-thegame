extends StaticBody2D

@export var enemy_scene: PackedScene
@export var max_enemies_alive: int = 5

var enemies_created: int = 0
var enemies_alive: int = 0
var enemies_dead: int = 0

var spawn_timer: float = 0.0

@onready var spawn_point: Marker2D = $SpawnPoint


func _ready() -> void:
	randomize()

	print("DOOR READY")
	print("Enemy scene: ", enemy_scene)
	print("Spawn point: ", spawn_point.global_position)

	# Start spawning immediately
	spawn_timer = randf_range(0.5, 2.0)


func _process(delta: float) -> void:

	if enemies_alive >= max_enemies_alive:
		return

	spawn_timer -= delta

	if spawn_timer <= 0.0:
		spawn_enemy()
		spawn_timer = randf_range(0.5, 2.0)


func spawn_enemy() -> void:

	if enemy_scene == null:
		print("DOOR ERROR: Enemy scene not assigned!")
		return

	if enemies_alive >= max_enemies_alive:
		return

	var enemy: Node = enemy_scene.instantiate()

	get_tree().current_scene.add_child(enemy)

	# Enemy comes directly out of this door
	enemy.global_position = spawn_point.global_position

	enemies_created += 1
	enemies_alive += 1

	print("ENEMY SPAWNED FROM DOOR")
	print("Position: ", enemy.global_position)
	print("Alive: ", enemies_alive, "/", max_enemies_alive)

	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died)

	randomize_enemy_direction(enemy)


func randomize_enemy_direction(enemy: Node) -> void:

	if not enemy.has_method("set_spawn_direction"):
		return

	var random_direction: int = randi_range(0, 1)

	if random_direction == 0:
		random_direction = -1
	else:
		random_direction = 1

	enemy.set_spawn_direction(random_direction)


func _on_enemy_died() -> void:

	enemies_alive -= 1
	enemies_dead += 1

	print("ENEMY DIED")
	print("Created: ", enemies_created)
	print("Alive: ", enemies_alive)
	print("Dead: ", enemies_dead)

	# Start a new random spawn delay
	spawn_timer = randf_range(0.5, 2.0)
