extends Node2D

@onready var help_button = $CanvasLayer/HelpButton
@onready var help_popup = $CanvasLayer/HelpPopup

func _ready():
	help_button.pressed.connect(_on_help_button_pressed)

func _on_help_button_pressed():
	print("Help button was pressed!")
	help_popup.set_image("res://images/formulės_1.jpg")
	help_popup.popup()
