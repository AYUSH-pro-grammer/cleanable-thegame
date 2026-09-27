extends CharacterBody2D

signal died

enum State {
	WANDER,
	CHASE
}

const WALK_SPEED: float = 80.0
const RUN_SPEED: float = 300.0
const GRAVITY: float = 1400.0
const DAMAGE_AMOUNT: int = 20

const MIN_WANDER_TIME: float = 0.8
const MAX_WANDER_TIME: float = 2.5
const WALL_CHECK_DISTANCE: float = 12.0

var current_state: State = State.WANDER

var direction: int = 1
var change_direction_timer: float = 0.0

var player: CharacterBody2D = null

@onready var detection_area: Area2D = $Area2D
@onready var damage_area: Area2D = $DamageArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:

	print("ENEMY READY")

	randomize()

	# Always start moving
	direction = [-1, 1].pick_random()
	change_direction_timer = randf_range(
		MIN_WANDER_TIME,
		MAX_WANDER_TIME
	)

	damage_area.body_entered.connect(_on_damage_body_entered)

	animated_sprite.play("running")


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	find_player()

	match current_state:

		State.WANDER:
			state_wander(delta)

		State.CHASE:
			state_chase()

	update_animation()

	move_and_slide()

	# If we hit something while wandering, turn around
	if current_state == State.WANDER:
		if is_on_wall():
			change_direction()


func find_player() -> void:

	var found_player: CharacterBody2D = null

	for body in detection_area.get_overlapping_bodies():

		if body.name == "player":

			if body is CharacterBody2D:
				found_player = body
				break

	if found_player != null:

		player = found_player

		if current_state != State.CHASE:
			change_state(State.CHASE)

	else:

		if player != null:
			player = null
			change_state(State.WANDER)


func change_state(new_state: State) -> void:

	current_state = new_state

	if current_state == State.WANDER:

		change_direction()


func state_wander(delta: float) -> void:

	change_direction_timer -= delta

	if change_direction_timer <= 0.0:
		change_direction()

	velocity.x = direction * WALK_SPEED


func state_chase() -> void:

	if player == null:

		velocity.x = direction * WALK_SPEED
		return

	var difference: float = player.global_position.x - global_position.x

	if difference > 10.0:

		velocity.x = RUN_SPEED
		direction = 1

	elif difference < -10.0:

		velocity.x = -RUN_SPEED
		direction = -1

	else:

		velocity.x = 0.0


func update_animation() -> void:

	if velocity.x != 0.0:
		animated_sprite.play("running")
	else:
		animated_sprite.play("default")

	if velocity.x < 0.0:
		animated_sprite.flip_h = true

	elif velocity.x > 0.0:
		animated_sprite.flip_h = false


func change_direction() -> void:

	direction = randi_range(0, 1)

	if direction == 0:
		direction = -1
	else:
		direction = 1

	change_direction_timer = randf_range(
		MIN_WANDER_TIME,
		MAX_WANDER_TIME
	)


func _on_damage_body_entered(body: Node2D) -> void:

	if body.name == "player":

		if body.has_method("take_damage"):
			body.take_damage(DAMAGE_AMOUNT)

		die()


func set_spawn_direction(new_direction: int) -> void:

	if new_direction < 0:
		direction = -1
	else:
		direction = 1

	velocity.x = direction * WALK_SPEED

	if direction < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false


func die() -> void:

	print("ENEMY BLASTED!")

	died.emit()

	velocity = Vector2.ZERO

	set_physics_process(false)

	animated_sprite.visible = false

	await get_tree().create_timer(0.1).timeout

	queue_free()
