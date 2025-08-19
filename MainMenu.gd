extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/Options.pressed.connect(_on_options_button_pressed)
	$VBoxContainer/Exit.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://ExamSelection.tscn")
	#ExamManager.start_exam()

func _on_options_button_pressed():
	print("Options")
	get_tree().change_scene_to_file("res://Options.tscn")

func _on_exit_button_pressed():
	print("Goodbye")
	get_tree().quit()
