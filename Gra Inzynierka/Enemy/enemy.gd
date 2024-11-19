extends CharacterBody2D
@export var hp = 10 #health points of enemy 
@export var movement_speed = 20.0 #movement speed can be changed in Editor
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("Player") #checks first node in the group, the only node is player so it will track player
func _ready(): #executes once at the begging
	anim.play("walking") #starts animation
func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position) #direction is based on player's position
	velocity=direction*movement_speed
	move_and_slide() 

	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
	
func _on_hurtbox_hurt(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
		
