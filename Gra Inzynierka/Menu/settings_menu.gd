extends Control
@onready var back_button = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.pressed.connect(self._on_back_button_pressed)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
