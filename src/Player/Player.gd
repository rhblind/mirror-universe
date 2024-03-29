extends KinematicBody2D
class_name Player

onready var state_machine: StateMachine = $StateMachine
onready var skin: Position2D = $Skin
onready var collider: CollisionShape2D = $CollisionShape2D setget ,get_collider
onready var stats: Stats = $Stats
onready var hitbox: Area2D = $HitBox
onready var camera_rig: Position2D = $CameraRig
onready var shaking_camera: Camera2D = $CameraRig/ShakingCamera
onready var ledge_wall_detector: Position2D = $LedgeWallDetector
onready var floor_detector: RayCast2D = $FloorDetector2
onready var pass_through: Area2D = $PassThrough

const FLOOR_NORMAL := Vector2.UP
var is_active := true setget set_is_active
var has_teleported := false
var last_checkpoint: Area2D = null

func _ready() -> void:
	# warning-ignore:return_value_discarded
	stats.connect("health_depleted", self, "_on_Player_health_depleted")
	# warning-ignore:return_value_discarded
	Events.connect("checkpoint_visited", self, "_on_Events_checkpoint_visited")

func take_damage(source: Hit) -> void:
	stats.take_damage(source)


### Setter and Getters

func get_collider() -> CollisionShape2D:
	return collider

func set_is_active(value: bool) -> void:
	is_active = value
	if collider:
		collider.disabled = not value
		ledge_wall_detector.is_active = value
		hitbox.monitoring = value
