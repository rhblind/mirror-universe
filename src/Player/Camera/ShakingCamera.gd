# Shakes the screen when is_shaking is set to true
# To make it react to events happening in the game world, use the Events signal routing singleton
# Uses different smoothing values depending on the active controller
tool
extends Camera2D

onready var timer = $Timer

export var amplitude = 4.0
export var damp_easing = 1.0
export var default_smoothing_speed := {
	mouse=3,
	gamepad=1
}
export var duration = 0.3 setget set_duration
export var is_shaking = false setget set_is_shaking


enum States {IDLE, SHAKING}
var state = States.IDLE


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Settings.connect("controls_changed", self, "reset_smoothing_speed")
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_ShakeTimer_timeout")

	self.duration = duration
	reset_smoothing_speed()
	set_process(false)

func _process(_delta: float) -> void:
	var damping = ease(timer.time_left / timer.wait_time, damp_easing)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping
	)

func _get_configuration_warning() -> String:
	return "%s requires a Timer child named \"Timer\"" % name if not $Timer else ""

func _change_state(new_state: int) -> void:
	match new_state:
		States.IDLE:
			offset = Vector2()
			set_process(false)
		States.SHAKING:
			set_process(true)
			timer.start()
	state = new_state

func reset_smoothing_speed() -> void:
	match Settings.controls:
		Settings.GAMEPAD:
			smoothing_speed = default_smoothing_speed.gamepad
		Settings.KBD_MOUSE:
			smoothing_speed = default_smoothing_speed.mouse

### Setters and Getters

func set_duration(value: float) -> void:
	duration = value
	if timer:
		timer.wait_time = duration

func set_is_shaking(value: bool) -> void:
	is_shaking = value
	if is_shaking:
		_change_state(States.SHAKING)
	else:
		_change_state(States.IDLE)


### Signal callbacks

func _on_ShakeTimer_timeout() -> void:
	self.is_shaking = false
