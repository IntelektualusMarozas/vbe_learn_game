extends Control

signal answer_selected(selected_answer)

@onready var question_text_label = $QuestionTextLabel
@onready var answer_options_container = $AnswerOptionsContainer

func display_question(question_data):
	question_text_label.text = question_data.klausimo_tekstas
	
	for child in answer_options_container.get_children():
		child.queue_free()
		
	if question_data.has("pasirinkimai"):
		for option_text in question_data.pasirinkimai:
			var button = Button.new()
			button.text = option_text
			button.pressed.connect(_on_answer_button_pressed.bind(option_text))
			answer_options_container.add_child(button)
			
func _on_answer_button_pressed(answer_text):
	print("Vartotojas pasirinko: ", answer_text)
	answer_selected.emit(answer_text)
