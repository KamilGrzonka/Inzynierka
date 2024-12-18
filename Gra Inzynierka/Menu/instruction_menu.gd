extends Control
@onready var back_button = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.pressed.connect(self._on_back_button_pressed)
	$RichTextLabel.bbcode_enabled = true
	$RichTextLabel.bbcode_text = "[center]Pokonaj nadciągające fale wrogów i przetrwaj jak najdłużej. Steruj postacią przy pomocy klawiszy WSAD. Unikaj pułapek i przeszkód. By wygrać musisz pokonać finalnego boss-a.[/center]"

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
