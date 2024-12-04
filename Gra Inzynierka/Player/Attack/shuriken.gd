extends Area2D

var level = 1 #starting level of weapon
var hp = 1 #amount of hits ice spear can take
var speed = 100 #speed of the missle
var damage = 5 #damage fo the attack
var knockback_value = 100 #knockback value
var attack_size = 1.0 #size of the attack

var target = Vector2.ZERO 
var angle = Vector2.ZERO 
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target) #directing the angle to point at the target
	rotation = angle.angle() + deg_to_rad(135) #returns the vector of radians
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knockback_value = 100
			attack_size = 1.0
	#missle will start small then it will scale back to the original size
	scale = Vector2(0.1, 0.1)
	#creating a tween
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) #setting up the tween
	tween.play() #playing the tween

func _physics_process(delta):
	position += angle*speed*delta
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp < 0:
		queue_free()
	
	
func _on_timer_timeout():
	# Usuwamy pocisk po czasie działania
	queue_free()
