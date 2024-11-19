extends Resource

class_name Spawn_info #class name so we can reference this later as a class

@export var time_start:int #telling the program what the expected type is
@export var time_end:int #when to spawn
@export var enemy:Resource #what enemy spawns
@export var enemy_number:int #number of enemies that spawn
@export var enemy_spawn_delay:int #seconds of delay between spawns

var spawn_delay_counter = 0 #tracks the delay seconds
