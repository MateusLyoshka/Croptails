extends Node2D

@export var corn_harvest_scene = preload("res://scenes/collectables/corn_harvest.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flowering: GPUParticles2D = $Flowering
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: hurt_component = $HurtComponent

var growth_state:DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

func _ready() -> void:
	watering_particles.emitting = false
	flowering.emitting = false
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	
func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering.emitting = true

func on_hurt(hit_damage:int) -> void:
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true

func on_crop_maturity() -> void:
	flowering.emitting = true
