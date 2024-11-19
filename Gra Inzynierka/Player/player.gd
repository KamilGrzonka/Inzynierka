extends CharacterBody2D
@onready var sprite = $Sprite2D #get sprite
@onready var walkingTimer = get_node("walkingTimer") #get timer
var movement_speed = 40.0
var hp = 100
#attack
var iceSpear = preload("res://Player/Attack/ice_attack.tscn")
@onready var iceSpearTimer = get_node("Attack/IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("Attack/IceSpearTimer/IceSpreatAttackTimer")
#ice spear
var ice_spear_ammo = 0
var ice_spear_base_ammo = 1
var ice_spear_attack_speed = 1.5
var ice_spear_level = 1
#enemy
var enemy_close = []

func _ready():
	attack()

func _physics_process(_delta): #once every 60th frame, checks what key is being pressed and 
	movement()

func movement():
	var x_move = Input.get_action_strength("Right") - Input.get_action_strength("Left") #calculating the direction on x axis
	var y_move = Input.get_action_strength("Down") - Input.get_action_strength("Up") #calculating the direction on y axis
	var move = Vector2(x_move, y_move) 
	if move.x > 0: #changing the side the player is facing according to his direction
		sprite.flip_h = true
	elif move.x < 0:
		sprite.flip_h = false
	if move != Vector2.ZERO: #if player moves animation plays, if not it doesn't
		if walkingTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame = 1
			walkingTimer.start()
	velocity = move.normalized()*movement_speed #making sure that movement speed is same in every direction
	move_and_slide()

func attack():
	if ice_spear_level > 0:
		# Timer działa w pętli dla regularnych ataków
		iceSpearTimer.wait_time = ice_spear_attack_speed
		iceSpearTimer.start()


func _on_hurtbox_hurt(damage):
	hp -= damage #player takes damage
	print(hp)


func _on_ice_spear_timer_timeout():
	ice_spear_ammo += ice_spear_base_ammo
	# Rozpocznij atak tylko, jeśli jest dostępna amunicja
	if ice_spear_ammo > 0:
		_start_attack_cycle()

func _start_attack_cycle():
	if ice_spear_ammo > 0:
		iceSpearAttackTimer.start()


func _on_ice_spreat_attack_timer_timeout():
	if ice_spear_ammo > 0:
		var ice_spear_attack = iceSpear.instantiate()
		ice_spear_attack.position = position
		ice_spear_attack.target = get_random_target()
		ice_spear_attack.level = ice_spear_level
		add_child(ice_spear_attack)
		ice_spear_ammo -= 1
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		# Wybierz domyślny cel jako pozycję odległą od gracza
		return global_position + Vector2(100, 0).rotated(rotation)
func _on_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
