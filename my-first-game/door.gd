extends Node2D

@export var enemy_scene: PackedScene
@export var enemies_to_spawn: int = 3
@export var spawn_once: bool = true

var enemies_created := 0
var enemies_alive := 0
var enemies_dead := 0
var has_spawned := false

@onready var spawn_points := [
	$SpawnPoint1,
	$SpawnPoint2,
	$SpawnPoint3
]

@onready var trigger: Area2D = $Area2D


func _ready() -> void:
	trigger.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:

	if body.name != "player":
		return

	if spawn_once and has_spawned:
		return

	spawn_enemies()


func spawn_enemies() -> void:

	if enemy_scene == null:
		print("DOOR ERROR: Enemy scene is not assigned!")
		return

	has_spawned = true

	for i in range(enemies_to_spawn):

		var enemy = enemy_scene.instantiate()

		var spawn_point = spawn_points[i % spawn_points.size()]

		enemy.global_position = spawn_point.global_position

		get_parent().add_child(enemy)

		enemies_created += 1
		enemies_alive += 1

		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)

	print("========== DOOR SPAWN ==========")
	print("Enemies created: ", enemies_created)
	print("Enemies alive: ", enemies_alive)
	print("Enemies dead: ", enemies_dead)
	print("================================")


func _on_enemy_died() -> void:

	enemies_alive -= 1
	enemies_dead += 1

	print("ENEMY DIED!")
	print("Enemies created: ", enemies_created)
	print("Enemies alive: ", enemies_alive)
	print("Enemies dead: ", enemies_dead)
