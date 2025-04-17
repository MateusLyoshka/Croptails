extends NodeState

@export var character: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var idle_state_time_interval: float = 2.0

@onready var idle_state_timer: Timer = Timer.new()

var timer_time_out :bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_timer_time_out)
	add_child(idle_state_timer)
	
func _on_process(_delta : float) -> void:
	pass
		


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if timer_time_out:
		transition.emit("walk")


func _on_enter() -> void:
	animated_sprite.play("idle")
	timer_time_out = false
	idle_state_timer.start()


func _on_exit() -> void:
	animated_sprite.stop()
	idle_state_timer.stop()
	
func on_timer_time_out():
	timer_time_out = true
