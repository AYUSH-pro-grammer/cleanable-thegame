extends CharacterBody2D

signal died

enum State {
	WANDER,
	CHASE
}

var current_state: State = State.WANDER

const WALK_SPEED = 80.0
const RUN_SPEED = 300.0
const GRAVITY = 1400.0
const DAMAGE_AMOUNT = 20

var direction := 0
var change_direction_timer := 0.0

var player: CharacterBody2D = null

@onready var detection_area: Area2D = $Area2D
@onready var damage_area: Area2D = $DamageArea
@onready var animated_sprite: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	randomize()
	change_direction()

	damage_area.body_entered.connect(_on_damage_body_entered)

	animated_sprite.play("default")


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

		player = null

		if current_state != State.WANDER:
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
		velocity.x = 0.0
		return

	var difference := player.global_position.x - global_position.x

	if difference > 0:
		velocity.x = RUN_SPEED
	elif difference < 0:
		velocity.x = -RUN_SPEED
	else:
		velocity.x = 0.0


func update_animation() -> void:

	if velocity.x != 0:
		animated_sprite.play("running")
	else:
		animated_sprite.play("default")

	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false


func change_direction() -> void:

	direction = randi_range(-1, 1)
	change_direction_timer = randf_range(1.0, 3.0)


func _on_damage_body_entered(body: Node2D) -> void:

	if body.name == "player":

		if body.has_method("take_damage"):
			body.take_damage(DAMAGE_AMOUNT)

		die()


func die() -> void:

	print("ENEMY BLASTED!")

	died.emit()

	velocity = Vector2.ZERO

	set_physics_process(false)

	animated_sprite.visible = false

	await get_tree().create_timer(0.1).timeout

	queue_free()
