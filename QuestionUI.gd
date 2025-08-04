extends Control

signal answer_selected(selected_answer)

func display_question(question_data):
	var question_text_label = $QuestionTextLabel
	var answer_options_container = $AnswerOptionsContainer
	var submit_button = $SubmitButton
	
	question_text_label.text = question_data.klausimo_tekstas
	submit_button.visible = false
	
	for child in answer_options_container.get_children():
		child.queue_free()
		
	var question_type = question_data.tipas

	if question_type == "vienas_pasirinkimas":
		if question_data.has("pasirinkimai"):
				for option_text in question_data.pasirinkimai:
					var button = Button.new()
					button.text = option_text
					button.pressed.connect(_on_answer_button_pressed.bind(option_text))
					answer_options_container.add_child(button)
					
	elif question_type == "keli_pasirinkimai":
		submit_button.visible = true
		submit_button.pressed.connect(_on_submit_multiple_choice)	
	
		if question_data.has("pasirinkimai"):
			for option_text in question_data.pasirinkimai:
					var check_box = CheckBox.new()
					check_box.text = option_text
					answer_options_container.add_child(check_box)
					
	if question_data.has("pasirinkimai"):
		for option_text in question_data.pasirinkimai:
			var button = Button.new()
			button.text = option_text
			button.pressed.connect(_on_answer_button_pressed.bind(option_text))
			answer_options_container.add_child(button)
			
func _on_answer_button_pressed(answer_text):
	print("Vartotojas pasirinko: ", answer_text)
	answer_selected.emit(answer_text)

func _on_submit_multiple_choice():
	return 0
