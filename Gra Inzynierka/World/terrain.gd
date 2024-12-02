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

	# Wybór tekstury
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(chunk_key) # Losowe nasionko zależne od pozycji chunku
	var texture_index = rng.randi_range(1, 10)
	var texture_path = "res://Textures/Grass/grass" + str(texture_index) + ".png"
	var texture = load(texture_path)

	# Debugowanie: sprawdzanie tekstury
	if texture == null:
		print("Nie znaleziono tekstury:", texture_path)
	else:
		print("Ładowanie tekstury:", texture_path)
	
	# Ustawienie tekstury
	var sprite = chunk.get_node("Sprite2D")
	if sprite:
		sprite.texture = texture
	else:
		print("Nie znaleziono Sprite2D w chunku!")

	add_child(chunk)
	active_chunks[chunk_key] = chunk

func remove_chunk(chunk_key: Vector2):
	if active_chunks.has(chunk_key):
		active_chunks[chunk_key].queue_free()
		active_chunks.erase(chunk_key)
		


