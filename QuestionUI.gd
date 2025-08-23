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
	var question_image_rect = $MainContainer/QuestionImage
	var answer_options_container = $MainContainer/AnswerOptionsContainer
	var answer_line_edit = $MainContainer/AnswerLineEdit
	var submit_button = $MainContainer/SubmitButton
	
	current_question_type = question_data.tipas
	#question_text_label.text = question_data.klausimo_tekstas
	
	if question_data.has("klausimo_tekstas"):
		question_text_label.text = question_data.klausimo_tekstas
		question_text_label.visible = true
	else:
		question_text_label.visible = false
	
	if question_data.has("klausimo_paveikslelis"):
		question_image_rect.texture = load(question_data.klausimo_paveikslelis)
		question_image_rect.visible = true
	else:
		question_image_rect.visible = false
	
	submit_button.visible = false
	answer_line_edit.visible = false
	answer_line_edit.clear()
	
	for child in answer_options_container.get_children():
		child.queue_free()
		
	var choices_are_images = question_data.get("pasirinkimai_yra_paveiksleliai", false)

	if current_question_type == "vienas_pasirinkimas":
		if question_data.has("pasirinkimai"):
				for option in question_data.pasirinkimai:
					var button = Button.new()
					if choices_are_images:
						button.icon = load(option)
					else:
						button.text = option
					button.pressed.connect(_on_answer_button_pressed.bind(option))
					answer_options_container.add_child(button)
					
	elif current_question_type == "keli_pasirinkimai":
		submit_button.visible = true
		if question_data.has("pasirinkimai"):
			for option in question_data.pasirinkimai:
				var check_box = CheckBox.new()
				if choices_are_images:
					#For CheckBox you cannot directly load image
					check_box.text = ""
					var texture_rect = TextureRect.new()
					texture_rect.texture = load(option)
					texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					texture_rect.custom_minimum_size = Vector2(100, 100)
					check_box.add_child(texture_rect)
				else:
					check_box.text = option
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
