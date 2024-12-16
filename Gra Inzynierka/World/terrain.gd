extends Node2D

@export var chunk_size = 16 # Rozmiar jednego chunku (np. 512x512)
@export var render_distance = 26 # Ile chunków w każdą stronę generować

@onready var player = get_node("../Player")
var active_chunks = {} # Słownik przechowujący aktywne chunki

func _process(delta):
	update_chunks()

func update_chunks():
	var player_chunk_x = int(player.position.x / chunk_size)
	var player_chunk_y = int(player.position.y / chunk_size)

	# Generuj chunki w obrębie render_distance
	for x in range(player_chunk_x - render_distance, player_chunk_x + render_distance + 1):
		for y in range(player_chunk_y - render_distance, player_chunk_y + render_distance + 1):
			var chunk_key = Vector2(x, y)
			if not active_chunks.has(chunk_key):
				spawn_chunk(chunk_key)

	# Usuń chunki poza zasięgiem
	for chunk_key in active_chunks.keys():
		if abs(chunk_key.x - player_chunk_x) > render_distance or abs(chunk_key.y - player_chunk_y) > render_distance:
			remove_chunk(chunk_key)

func spawn_chunk(chunk_key: Vector2):
	var chunk_scene = preload("res://Terrain/chunk.tscn")
	var chunk = chunk_scene.instantiate()
	chunk.position = chunk_key * chunk_size

	var rng = RandomNumberGenerator.new()
	rng.seed = hash(chunk_key) # Deterministyczne losowanie na podstawie pozycji chunku

	# Sprawdź, czy ma pojawić się trawa czy pułapka (10% szans na pułapkę)
	var is_trap = rng.randi_range(1, 100) <= 2 # 10% szansy na pułapkę

	if is_trap:
		# Ładowanie pułapki
		var trap_texture_path = "res://Textures/Traps/trap.png"
		var texture = load(trap_texture_path)

		# Debugowanie
		if texture == null:
			print("Nie znaleziono tekstury pułapki:", trap_texture_path)
		else:
			print("Generowanie pułapki:", trap_texture_path)

		# Ustawienie tekstury pułapki
		var sprite = chunk.get_node("Sprite2D")
		if sprite:
			sprite.texture = texture
			sprite.scale = Vector2(0.5, 0.5) # Skalowanie tekstury
			sprite.centered = true # Wyśrodkowanie tekstury
			sprite.region_enabled = true # Włączenie regionu tekstury
			sprite.region_rect = Rect2(0, 0, 32, 32) # Przycinanie tekstury
		else:
			print("Nie znaleziono Sprite2D w chunku!")

	# Dodanie CollisionShape dla obszaru pułapki
		var trap_area = Area2D.new()
		trap_area.name = "TrapArea"
		var trap_collision = CollisionShape2D.new()
		var trap_shape = RectangleShape2D.new()
		trap_shape.size = Vector2(16, 16) # Możesz dostosować wielkość
		trap_collision.shape = trap_shape
		trap_area.add_child(trap_collision)

		chunk.add_child(trap_area)

		# Dodajemy detekcję kolizji
		trap_area.connect("body_entered", Callable(self, "_on_trap_area_entered"))
		
	else:
		# Generowanie standardowej trawy
		var texture_index = rng.randi_range(1, 10)
		var texture_path = "res://Textures/Grass/grass" + str(texture_index) + ".png"
		var texture = load(texture_path)

		# Debugowanie
		if texture == null:
			print("Nie znaleziono tekstury:", texture_path)
		else:
			print("Ładowanie trawy:", texture_path)

		# Ustawienie tekstury
		var sprite = chunk.get_node("Sprite2D")
		if sprite:
			sprite.texture = texture
		else:
			print("Nie znaleziono Sprite2D w chunku!")

	# Dodanie chunku do świata
	add_child(chunk)
	active_chunks[chunk_key] = chunk

func remove_chunk(chunk_key: Vector2):
	if active_chunks.has(chunk_key):
		active_chunks[chunk_key].queue_free()
		active_chunks.erase(chunk_key)
		
# Funkcja, która będzie wywoływana, gdy gracz wejdzie w pułapkę
func _on_trap_area_entered(body):
	if body.is_in_group("Player"):  # Sprawdzamy, czy to gracz
		var damage = 10  # Możesz ustawić dowolną wartość obrażeń
		body._on_hurtbox_hurt(damage, Vector2.ZERO, 0)  # Zadanie obrażeń graczowi

