# Loads and unloads levels
extends Node


var _game: Node = null
var _player: Player = null
var _level: Node2D = null

# Keeps all available scenes
onready var scene_tree := get_tree()

func setup(game: Node, player: Player, level: PackedScene) -> void:
	_game = game
	_player = player
	load_level(level)

func load_level(NewLevel: PackedScene, portal_name: String = "") -> void:
	if _level:
		scene_tree.paused = true

		# Wait for the "faded_to_black" signal callbacks to finish
		_game.transition.fade_to_black()
		yield(_game.transition, "faded_to_black")

		# Clean up the previous level
		_level.queue_free()
		yield(_level, "tree_exited")

	_game.remove_child(_player)
	_level = NewLevel.instance()

	var player_position_node: Node2D = (
		_level.get_node("Checkpoints").get_child(0) if portal_name.empty() else _level.get_node("Portals/%s" % portal_name)
	)
	_player.global_position = player_position_node.global_position
	_player.has_teleported = not portal_name.empty()

	for checkpoint_name in _game.visited_checkpoints.get(_level.name, []):
		var checkpoint: Area2D = _level.get_node("Checkpoints/%s" % checkpoint_name)
		checkpoint.is_visited = true

	_game.level = _level
	_game.add_child(_level)
	_game.add_child(_player)

	_game.transition.fade_back_in()

	scene_tree.paused = false
