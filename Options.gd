extends Control

@onready var feedback_checkbutton = $VBoxContainer/CheckButton

func _ready():
	feedback_checkbutton.button_pressed = SettingsManager.show_instant_feedback
	
	feedback_checkbutton.toggled.connect(_on_feedback_toggled)
	$VBoxContainer/Button.pressed.connect(_on_back_button_pressed)

func _on_feedback_toggled(is_pressed):
	SettingsManager.show_instant_feedback = is_pressed
	print("Show instant feedback/answer set to: ", SettingsManager.show_instant_feedback)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
