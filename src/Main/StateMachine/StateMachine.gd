# Generic State Machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
extends Node
class_name StateMachine

export var initial_state := NodePath()

onready var state: State = get_node(initial_state) setget set_state
onready var _current_state := state.name
onready var _previous_state := state.name


func _init() -> void:
	add_to_group("state_machine")

func _ready() -> void:
	yield(owner, "ready")
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)

func _physics_process(delta: float) -> void:
	state.physics_process(delta)

func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		return

	var target_state := get_node(target_state_path)

	state.exit()
	self.state = target_state
	state.enter(msg)

func set_state(value: State) -> void:
	_previous_state = state.name
	_current_state = value.name
	state = value

