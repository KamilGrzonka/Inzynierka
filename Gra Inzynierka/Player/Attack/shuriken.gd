extends Area2D

var target= Vector2.ZERO # Zmienna target jako Vector2
var level = 1
var hp = 1
var speed = 100 # prędkość rotacji
var damage = 5
var knockback_value = 100
var attack_size = 1.0

var orbit_duration = 5.0 # Czas krążenia w sekundach
var orbit_radius = 50 # Promień orbity
var orbit_speed = 2.0 # Prędkość obrotu (w radianach na sekundę)

@onready var player = get_tree().get_first_node_in_group("Player") # Znajdź gracza
var angle = Vector2.ZERO # Aktualny kąt orbity (w radianach)
var timer = Timer.new() # Timer życia shurikena

func _ready():
	# Ustaw początkową pozycję na orbicie
	angle = 0
	global_position = player.global_position + Vector2(orbit_radius, 0)
	# Skalowanie wejścia
	scale = Vector2(0.1, 0.1)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	# Ustaw timer na czas życia
	timer.wait_time = orbit_duration
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout) # Podłącz timeout bezpośrednio do metody
	add_child(timer)
	timer.start()

func _physics_process(delta):
	# Oblicz nową pozycję na orbicie
	angle += orbit_speed * delta # Aktualizuj kąt
	if angle > TAU: # Jeśli kąt przekroczy 360 stopni, zresetuj go
		angle -= TAU
	# Oblicz nową pozycję globalną na podstawie orbity
	global_position = player.global_position + Vector2(orbit_radius, 0).rotated(angle)

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_timer_timeout():
	# Usuń shuriken po zakończeniu orbity
	queue_free()

