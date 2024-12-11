extends CharacterBody2D
@export var hp = 10 #health points of enemy 
@export var movement_speed = 30.0 #movement speed can be changed in Editor
@export var knockback_recovery = 3
@export var damage = 1
var knockback = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var hitbox = $Hitbox
@onready var player = get_tree().get_first_node_in_group("Player") #checks first node in the group, the only node is player so it will track player

func _ready(): #executes once at the begging
	anim.play("walking") #starts animation
	hitbox.damage = damage
	
func _physics_process(_delta):
	#knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)

	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	#velocity += knockback  # Dodajemy knockback do prędkości

	move_and_slide()  # Ruch postaci

	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
	
func _on_hurtbox_hurt(damage, angle, knockback_value):
	hp -= damage
	knockback = angle * knockback_value
	if hp <= 0:
		queue_free()
		
