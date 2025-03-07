extends Node2D

@export var obstacle: PackedScene
@export var spawn_interval: float = 1.0  # Time between spawns
@export var spawn_range_x: float = 1000  # Adjust the range of spawn

var timer: Timer

func _ready():
	# Create and configure a Timer node
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(spawn)
	add_child(timer)  # Attach the timer to the spawner

func spawn():
	if not obstacle:
		print("Error: No obstacle scene assigned!")
		return

	var spawned = obstacle.instantiate()
	get_parent().add_child(spawned)

	# Randomize spawn position
	var spawn_pos = global_position
	spawn_pos.x += randf_range(-spawn_range_x, spawn_range_x)
	spawned.global_position = spawn_pos

	# Make sure the fish gets removed after leaving the screen
	spawned.connect("tree_exited", Callable(self, "_on_fish_removed"))

func _on_fish_removed():
	print("A fish was removed from the scene.")
