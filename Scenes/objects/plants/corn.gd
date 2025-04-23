extends Node2D

@export var corn_harvest_scene = preload("res://scenes/collectables/corn_harvest.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flowering: GPUParticles2D = $Flowering
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: hurt_component = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed
var last_growth_state: int = -1
var has_been_harvested: bool = false

func _ready() -> void:
	watering_particles.emitting = false
	flowering.emitting = false
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(delta: float) -> void:	
	var new_state = growth_cycle_component.get_current_growth_state()
	if new_state != last_growth_state:
		last_growth_state = new_state
		growth_state = new_state
		sprite_2d.frame = growth_state
		set_flowering_emission(growth_state == DataTypes.GrowthStates.Maturity)

func on_hurt(hit_damage: int) -> void:
	if !growth_cycle_component.is_watered \
	and growth_cycle_component.get_current_growth_state() < DataTypes.GrowthStates.Maturity:
		watering_particles.emitting = true
		await get_tree().create_timer(2.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true

func on_crop_maturity() -> void:
	set_flowering_emission(true)

func on_crop_harvesting() -> void:
	if has_been_harvested:
		return
	has_been_harvested = true

	var corn_harvesting = corn_harvest_scene.instantiate() as Node2D
	corn_harvesting.global_position = global_position
	get_parent().add_child(corn_harvesting)
	queue_free()

func set_flowering_emission(state: bool) -> void:
	flowering.emitting = state
