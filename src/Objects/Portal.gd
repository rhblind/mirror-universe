extends Area2D

export(bool) var active := true
export(String, FILE) var next_level_file_path := ""
export(String) var next_level_portal_name := ""

func _get_configuration_warning() -> String:
	return "next_level_file_path is mandatory!" if active and next_level_file_path.empty() else ""

func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")


### Callback signals

func _on_body_entered(body: PhysicsBody2D) -> void:
	if active and body is Player and not body.has_teleported:
		var NextLevel = load(next_level_file_path)
		LevelLoader.trigger(NextLevel, next_level_portal_name)
	body.has_teleported = false
