extends Control

func _ready():
	var exams_list_container = $MainContainer/ExamListContainer
	
	var exam_files = ExamManager.get_available_exams()
	
	for file_path in exam_files:
		var exam_button = Button.new()
		
		var file = FileAccess.open(file_path, FileAccess.READ)
		var content = JSON.parse_string(file.get_as_text())
		
		if content and content.has("egzamino_pavadinimas"):
			exam_button.text = content.egzamino_pavadinimas
		else:
			exam_button.text = file_path.get_file().replace(".json", "")
			
		#Connect exam to button
		exam_button.pressed.connect(_on_exam_button_pressed.bind(file_path))
		#Add new button to the container
		exams_list_container.add_child(exam_button)
		
	#Connect the back button's signal
	$MainContainer/BackButton.pressed.connect(_on_back_button_pressed)

func _on_exam_button_pressed(exam_filepath):
	ExamManager.start_exam(exam_filepath)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
