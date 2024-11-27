extends CharacterBody2D
@onready var idle_sprite = $IdleSprite #get sprite
@onready var run_sprite = $RunSprite #get sprite
@onready var walkingTimer = get_node("walkingTimer") #get timer
var movement_speed = 50.0
var hp = 100
#attack
var iceSpear = preload("res://Player/Attack/ice_attack.tscn")
@onready var iceSpearTimer = get_node("Attack/IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("Attack/IceSpearTimer/IceSpreatAttackTimer")
#ice spear
var basic_attack_ammo = 0
var basic_attack_base_ammo = 1
var basic_attack_speed = 1.5
var basic_attack_level = 1
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
		idle_sprite.flip_h = false
		run_sprite.flip_h = false
	elif move.x < 0:
		idle_sprite.flip_h = true
		run_sprite.flip_h = true
	# Obsluga zmiany animacji
	if move != Vector2.ZERO: # Gracz sie porusza
		if idle_sprite.visible: # Przełacz na RunSprite
			idle_sprite.visible = false
			run_sprite.visible = true
		update_animation(run_sprite) # Aktualizuj animacje Run
	else: # Gracz stoi w miejscu
		if run_sprite.visible: # Przełacz na IdleSprite
			run_sprite.visible = false
			idle_sprite.visible = true
		update_animation(idle_sprite) # Aktualizuj animacje Idle
	velocity = move.normalized()*movement_speed #making sure that movement speed is same in every direction
	move_and_slide()

# Funkcja do aktualizacji animacji
func update_animation(sprite):
	if walkingTimer.is_stopped():
		if sprite.frame >= sprite.hframes - 1:
			sprite.frame = 0
		else:
			sprite.frame += 1
		walkingTimer.start()

func attack():
	if basic_attack_level > 0:
		# Timer dziala w petli dla regularnych atakow
		iceSpearTimer.wait_time = basic_attack_speed
		iceSpearTimer.start()


func _on_hurtbox_hurt(damage, _angle, _knockback):
	hp -= damage #player takes damage
	print(hp)


func _on_ice_spear_timer_timeout():
	basic_attack_ammo += basic_attack_base_ammo
	#Start only if there is ammo avaiable
	if basic_attack_ammo > 0:
		_start_attack_cycle()

func _start_attack_cycle():
	if basic_attack_ammo > 0:
		iceSpearAttackTimer.start()


func _on_ice_spreat_attack_timer_timeout():
	if basic_attack_ammo > 0:
		var basic_attack = iceSpear.instantiate() #Create instance of ice spear
		basic_attack.position = position
		basic_attack.target = get_random_target()
		basic_attack.level = basic_attack_level
		add_child(basic_attack)
		basic_attack_ammo -= 1
		
#Choosing random enemy in player area as a target
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		#If there are no enemies nearby choose random position that is far from the player as a target
		return global_position + Vector2(100, 0).rotated(rotation)
		
#If the body that is not in the array enters the area it will be added to the list
func _on_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)
#If the body leaves the area it will be removed from the list
func _on_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
