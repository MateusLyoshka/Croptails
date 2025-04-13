extends NodeState

@export var character: NpcCharacter
@export var animated_sprite: AnimatedSprite2D
@export var navigation_agent : NavigationAgent2D
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

var speed: float

func _ready() -> void:
	navigation_agent.velocity_computed.connect(on_safe_velocity_computed)
	
	call_deferred("character_setup")
	
func character_setup() -> void:
	await get_tree().process_frame
	await get_tree().physics_frame
	
	set_movement_target()
	
func set_movement_target() -> void:
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(navigation_agent.get_navigation_map(), navigation_agent.navigation_layers, false)
	print("Target pos: ", target_position)
	navigation_agent.target_position = target_position
	speed = randf_range(min_speed, max_speed)
	
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if navigation_agent.is_navigation_finished():
		character.current_cycles += 1
		set_movement_target()
	
	var target_position: Vector2 = navigation_agent.get_next_path_position()
	var target_direction: Vector2 = character.global_position.direction_to(target_position)
	
	var velocity: Vector2 = target_direction * speed
	
	if navigation_agent.avoidance_enabled:
		animated_sprite.flip_h = velocity.x < 0
		navigation_agent.velocity = velocity
	else: 
		character.velocity = velocity
	character.move_and_slide()
	
func on_safe_velocity_computed(safe_velocity:Vector2) -> void:
	animated_sprite.flip_h = safe_velocity.x < 0
	character.velocity = safe_velocity
	character.move_and_slide()

func _on_next_transitions() -> void:
	if character.current_cycles == character.walk_cycles:
		character.velocity = Vector2.ZERO
		transition.emit("idle")


func _on_enter() -> void:
	animated_sprite.play("walk")
	character.current_cycles = 0


func _on_exit() -> void:
	animated_sprite.stop()
