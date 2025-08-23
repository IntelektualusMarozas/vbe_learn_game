extends Control

signal answer_selected(selected_answer)

var current_question_type = ""

@onready var feedback_label = $MainContainer/FeedbackLabel
@onready var feedback_timer = $FeedbackTimer

func _ready():
	$MainContainer/SubmitButton.pressed.connect(_on_submit_multiple_choice)
	feedback_timer.timeout.connect(_on_feedback_timer_timeout)

func set_inputs_disabled(is_disabled):
	$MainContainer/SubmitButton.disabled = is_disabled
	$MainContainer/AnswerLineEdit.editable = not is_disabled
	
	for child in $MainContainer/AnswerOptionsContainer.get_children():
		child.disabled = is_disabled

func show_feedback(message, is_correct):
	feedback_label.text = message
	if is_correct:
		feedback_label.modulate = Color.GREEN
	else:
		feedback_label.modulate = Color.DARK_RED
	feedback_label.show()
	feedback_timer.start()
	
func _on_feedback_timer_timeout():
	feedback_label.hide()

func display_question(question_data):
	var question_text_label = $MainContainer/QuestionTextLabel
	var answer_options_container = $MainContainer/AnswerOptionsContainer
	var answer_line_edit = $MainContainer/AnswerLineEdit
	var submit_button = $MainContainer/SubmitButton
	
	current_question_type = question_data.tipas
	question_text_label.text = question_data.klausimo_tekstas
	
	submit_button.visible = false
	answer_line_edit.visible = false
	answer_line_edit.clear()
	
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
		#submit_button.pressed.connect(_on_submit_multiple_choice)	
		if question_data.has("pasirinkimai"):
			for option_text in question_data.pasirinkimai:
					var check_box = CheckBox.new()
					check_box.text = option_text
					answer_options_container.add_child(check_box)
	elif current_question_type == "atviras_klausimas":
		submit_button.visible = true
		answer_line_edit.visible = true
			
func _on_answer_button_pressed(answer_text):
	print("Vartotojas pasirinko: ", answer_text)
	set_inputs_disabled(true)
	answer_selected.emit(answer_text)

func _on_submit_multiple_choice():
	set_inputs_disabled(true)
	
	if current_question_type == "keli_pasirinkimai":
		var selected_options = []
		var answer_options_container = $MainContainer/AnswerOptionsContainer
		
		for child in answer_options_container.get_children():
			if child is CheckBox and child.button_pressed:
				selected_options.append(child.text)
		print("Vartotojas pasirinko:", selected_options)
		answer_selected.emit(selected_options)
	elif current_question_type == "atviras_klausimas":
		var answer_text = $MainContainer/AnswerLineEdit.text
		print("Vartotojas pasirinko: ", answer_text)
		answer_selected.emit(answer_text)
