extends CharacterBody2D
@onready var idle_sprite = $IdleSprite #get sprite
@onready var run_sprite = $RunSprite #get sprite
@onready var hurt_sprite = $HurtSprite #get sprite
@onready var walkingTimer = get_node("walkingTimer") #get timer
@onready var healtBar = get_node("%HealthBar") #get health bar
@onready var igTimer = get_node("%IGTimer") #get in game timer
@onready var deathScreen = get_node("%DeathScreen") #get death screen
@onready var lblResult = get_node("%lblResult") #get result label
@onready var victorySound = get_node("%VictorySound") #get vitory sound
@onready var deathSound = get_node("%DeathSound") #get death sound


var time = 0
var movement_speed = 50.0
var hp = 100
var maxhp = 100
var is_hurt = false # Flaga obrażeń
var hurt_duration = 0.35 # Czas trwania animacji obrażeń (w sekundach)
#attack
var sword = preload("res://Player/Attack/sword_attack.tscn")
@onready var swordTimer = get_node("%SwordTimer")
@onready var swordAttackTimer = get_node("%SwordAttackTimer")
var shuriken = preload("res://Player/Attack/shuriken.tscn")
@onready var shurikenTimer = get_node("%ShurikenTimer")
@onready var shurikenAttackTimer = get_node("%ShurikenAttackTimer")
#basic attack
var sword_attack_ammo = 0
var sword_attack_base_ammo = 1
var sword_attack_speed = 1.5
var sword_attack_level = 1
#basic attack
var shuriken_attack_ammo = 0
var shuriken_attack_base_ammo = 1
var shuriken_attack_speed = 1.5
var shuriken_attack_level = 1
#enemy
var enemy_close = []

func _ready():
	add_to_group("Player")
	attack()
	_on_hurtbox_hurt(0,0,0)

func _physics_process(_delta): #once every 60th frame, checks what key is being pressed and 
	movement()

func movement():
	var x_move = Input.get_action_strength("Right") - Input.get_action_strength("Left") #calculating the direction on x axis
	var y_move = Input.get_action_strength("Down") - Input.get_action_strength("Up") #calculating the direction on y axis
	var move = Vector2(x_move, y_move) 
	if move.x > 0: #changing the side the player is facing according to his direction
		idle_sprite.flip_h = false
		run_sprite.flip_h = false
		hurt_sprite.flip_h = false
	elif move.x < 0:
		idle_sprite.flip_h = true
		run_sprite.flip_h = true
		hurt_sprite.flip_h = true
	# Animation handling (hurt animation takes priority)
	if is_hurt:
		if not hurt_sprite.visible: # Ensure only hurt_sprite is visible
			idle_sprite.visible = false
			run_sprite.visible = false
			hurt_sprite.visible = true
		update_animation(hurt_sprite) # Update hurt animation
	elif move != Vector2.ZERO: # Player is moving
		if idle_sprite.visible: # Switch to RunSprite
			idle_sprite.visible = false
			hurt_sprite.visible = false
			run_sprite.visible = true
		update_animation(run_sprite) # Update run animation
	else: # Player is idle
		if run_sprite.visible: # Switch to IdleSprite
			run_sprite.visible = false
			hurt_sprite.visible = false
			idle_sprite.visible = true
		update_animation(idle_sprite) # Update idle animation
	
# Normalizing movement speed and moving the player
	velocity = move.normalized() * movement_speed
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
	if sword_attack_level > 0:
		# Timer dziala w petli dla regularnych atakow
		swordTimer.wait_time = sword_attack_speed
		swordTimer.start()
	if shuriken_attack_level > 0:
		# Timer dziala w petli dla regularnych atakow
		shurikenTimer.wait_time = shuriken_attack_speed
		shurikenTimer.start()
		


func _on_hurtbox_hurt(damage, _angle, _knockback):
	if is_hurt: # Prevent interrupting ongoing hurt animation
		return

	hp -= damage # Player takes damage
	healtBar.max_value = maxhp
	healtBar.value = hp
	print(hp)
	is_hurt = true
	hurt_sprite.visible = true
	idle_sprite.visible = false
	run_sprite.visible = false
	hurt_sprite.frame = 0 # Reset hurt animation to the first frame

# Timer to end hurt animation
	var hurt_timer = Timer.new()
	hurt_timer.wait_time = hurt_duration
	hurt_timer.one_shot = true
	add_child(hurt_timer)

	hurt_timer.timeout.connect(_end_hurt_animation)
	hurt_timer.start()
	
	if hp<=0:
		death()

func _end_hurt_animation():
	is_hurt = false # Reset hurt state
	hurt_sprite.visible = false

# Restore appropriate sprite after hurt animation
	if velocity != Vector2.ZERO:
		run_sprite.visible = true
	else:
		idle_sprite.visible = true

func _on_sword_timer_timeout():
	sword_attack_ammo += sword_attack_base_ammo
	#Start only if there is ammo avaiable
	if sword_attack_ammo > 0:
		_start_attack_cycle()

func _on_shuriken_timer_timeout():
	shuriken_attack_ammo += shuriken_attack_base_ammo
	#Start only if there is ammo avaiable
	if shuriken_attack_ammo > 0:
		_start_attack_cycle()

func _start_attack_cycle():
	if sword_attack_ammo > 0:
		swordAttackTimer.start()
	if shuriken_attack_ammo > 0:
		shurikenAttackTimer.start()


func _on_sword_attack_timer_timeout():
	if sword_attack_ammo > 0:
		var sword_attack = sword.instantiate() #Create instance of ice spear
		sword_attack.position = position
		sword_attack.target = get_random_target()
		sword_attack.level = sword_attack_level
		add_child(sword_attack)
		sword_attack_ammo -= 1
		
func _on_shuriken_attack_timer_timeout():
	if shuriken_attack_ammo > 0:
		var shuriken_attack = shuriken.instantiate() # Create instance of shuriken
		shuriken_attack.position = position
		shuriken_attack.target = global_position # Przypisanie global_position do target
		shuriken_attack.level = shuriken_attack_level
		add_child(shuriken_attack)
		shuriken_attack_ammo -= 1

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
		
func change_time(argtime=0):
	time = argtime
	var get_min = int(time/60)
	var get_sec = time % 60
	if get_min < 10:
		get_min = str(0, get_min)
	if get_sec < 10:
		get_sec = str(0, get_sec)
	igTimer.text = str(get_min,":",get_sec)
	
func death():
	deathScreen.visible = true
	get_tree().paused = true
	var tween = deathScreen.create_tween()
	tween.tween_property(deathScreen, "position", Vector2(220,50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		lblResult.text = "Wygrałeś"
		victorySound.play()
	else:
		lblResult.text = "Przegrałeś"
		deathSound.play()
	

func _on_button_menu_pressed():
	get_tree().paused = false
	var scene = get_tree().change_scene_to_file("res://Menu/main_menu.tscn")
