extends Control

# Zmienna do przechowywania odniesień do przycisków
@onready var play_button = $PlayButton
@onready var instruction_button = $InstructionButton
@onready var exit_button = $ExitButton

func _ready():
	# Podłączenie sygnałów do metod przy użyciu Callable
	play_button.pressed.connect(self._on_play_button_pressed)
	instruction_button.pressed.connect(self._on_instruction_button_pressed)
	exit_button.pressed.connect(self._on_exit_button_pressed)

# Metoda do przejścia do sceny gry
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")

# Metoda do przejścia do sceny instrukcji
func _on_instruction_button_pressed():
	get_tree().change_scene_to_file("res://Menu/instruction_menu.tscn")

# Metoda do zamknięcia aplikacji
func _on_exit_button_pressed():
	get_tree().quit()


