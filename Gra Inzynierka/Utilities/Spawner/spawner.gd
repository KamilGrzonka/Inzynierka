extends Node2D

@export var spawns : Array[Spawn_info] = []  #thanks to class name we can reference class made in other script

@onready var player = get_tree().get_first_node_in_group("Player")
var time = 0


func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns #enemy_spawns equlas spawn_info array
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter +=1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = load(str(i.enemy.resource_path))
				var counter = 0
				while counter < i.enemy_number:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn) #adding enemy to the world
					counter += 1
					


func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bot_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bot_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var position_side = ["up", "down", "left", "right"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match position_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bot_left
			spawn_pos2 = bot_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bot_left
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bot_right
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
	
