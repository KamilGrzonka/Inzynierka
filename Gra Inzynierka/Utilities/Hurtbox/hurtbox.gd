extends Area2D

@export_enum("Cooldown", "HitOne", "DisableHitBox") var HurtBoxType = 0
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)


func _on_area_entered(area):
	if area.is_in_group("attack"): #hitbox
		if not area.get("damage") == null: #checks if it has damage
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set", "disabled", true) #disables hitbox collisions
					disableTimer.start() #starts 0.5 timer
				1: #HitOne
					pass
				2: #DisableHitBox
					if area.has_method("tempdisable"): #checks if area has tempdisable method
						area.tempdisable() #call hitbox.tempdisable()
					
			var damage = area.damage
			emit_signal("hurt", damage)	 #emit signal hurt


func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false) #enables hitbox collisions
