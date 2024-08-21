extends CharacterBody2D
@onready var sprite = $Sprite2D #get sprite
@onready var walkingTimer = get_node("walkingTimer") #get timer
var movement_speed = 40.0
var hp = 100
func _physics_process(delta): #once every 60th frame, checks what key is being pressed and 
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


func _on_hurtbox_hurt(damage):
	hp -= damage #player takes damage
	print(hp)
