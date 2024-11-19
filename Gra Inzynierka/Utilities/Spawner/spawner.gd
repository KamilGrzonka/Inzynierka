extends Node2D

@export var spawns : Array[Spawn_info] = []  #thanks to class name we can reference class made in other script

@onready var player = get_tree().get_first_node_in_group("Player")
var time = 0


func _on_timer_timeout():
	time += 1 #increase timer by 1
	var enemy_spawns = spawns #enemy_spawns equlas spawn_info array
	for i in enemy_spawns: #program goes through the enemy array
		if time >= i.time_start and time <= i.time_end: #between time_start and time_end
			if i.spawn_delay_counter < i.enemy_spawn_delay: #check if there is delay
				i.spawn_delay_counter +=1 #increase counter by 1 for the next time
			else:
				i.spawn_delay_counter = 0 #reset the delay counter
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_number: #spawn enemies
					var enemy_spawn = new_enemy.instantiate() #create instance of packed scene
					enemy_spawn.global_position = get_random_position() #set global_position
					add_child(enemy_spawn) #adding enemy to the world
					counter += 1 #increase until all enemies are spawned
					


func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4) #it takes view port size and multiplies it slightly so it is a bit bigger than view port
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2) #set corners
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bot_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bot_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var position_side = ["up", "down", "left", "right"].pick_random() #picks random value
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	#picks a side
	match position_side:
		"up": #enemy spawns in random place above the player
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down": #enemy spawns in random place below the player
			spawn_pos1 = bot_left
			spawn_pos2 = bot_right
		"left": #enemy spawns in random place on the left side
			spawn_pos1 = top_left
			spawn_pos2 = bot_left
		"right": #enemy spawns in random place on the right side
			spawn_pos1 = top_right
			spawn_pos2 = bot_right
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y) #get value between the points
	return Vector2(x_spawn, y_spawn) #return vector2
	
