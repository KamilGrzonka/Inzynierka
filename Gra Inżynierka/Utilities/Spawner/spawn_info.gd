extends Resource

class_name Spawn_info #class name so we can reference this later as a class

@export var time_start:int #telling the program what the expected type is
@export var time_end:int
@export var enemy:Resource
@export var enemy_number:int
@export var enemy_spawn_delay:int

var spawn_delay_counter = 0
