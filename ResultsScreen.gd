extends Control

@onready var results_grid = $MainContainer/ScrollContainer/ResultGrid

func _ready():
	$MainContainer/MenuButton.pressed.connect(_on_menu_button_pressed)
	
	var exam_results = ExamManager.results
	
	add_header("Klausimas")
	add_header("Jūsų atsakymas")
	add_header("Teisingas atsakymas")
	add_header("Laikas")
	
	for result in exam_results:
		populate_row(result)
	
func add_header(text):
	var header = Label.new()
	header.text = text
	#Design could be addede here
	results_grid.add_child(header)

func populate_row(result_data):
	var color = Color.RED
	if result_data.is_correct:
		color = Color.GREEN
	
	var id_label = Label.new()
	id_label.text = result_data.id
	id_label.modulate = color
	
	var user_answer_label = Label.new()
	user_answer_label.text = str(result_data.user_answer)
	user_answer_label.modulate = color
	
	var correct_answer_label = Label.new()
	correct_answer_label.text = str(result_data.correct_answer)
	correct_answer_label.modulate = color
	
	var time_label = Label.new()
	time_label.text = "%.2f sek." % result_data.time_taken
	time_label.modulate = color
	
	results_grid.add_child(id_label)
	results_grid.add_child(user_answer_label)
	results_grid.add_child(correct_answer_label)
	results_grid.add_child(time_label)
	
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
