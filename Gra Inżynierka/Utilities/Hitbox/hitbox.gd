extends Area2D

@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var disableHitBoxTimer = $DisableHitBoxTimer

func tempdisable():
	collision.call_deferred("set", "disabled", true) #disables hitbox collisions
	disableHitBoxTimer.start()


func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set", "disabled", false) #enables hitbox collisions
