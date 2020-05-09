# The player's animated skin. Provides a simple interface to play animations.
extends Position2D

signal animation_finished(name)
onready var animation: AnimationPlayer = $AnimationPlayer
onready var floor_detector: FloorDetector = $FloorDetector


func _ready() -> void:
	# warning-ignore:return_value_discarded
	animation.connect("animation_finished", self, "_on_AnimimationPlayer_animation_finished")

func _physics_process(_delta: float) -> void:
	floor_detector.force_raycast_update()

func play(name: String, data: Dictionary = {}) -> void:
	# Plays the requested animation and safeguards against errors
	assert(name in animation.get_animation_list())
	animation.stop()
	if name == "ledge":
		assert('from' in data)
		position = data.from
	animation.play(name)

### Signal callbacks

func _on_AnimimationPlayer_animation_finished(name: String) -> void:
	emit_signal("animation_finished", name)
