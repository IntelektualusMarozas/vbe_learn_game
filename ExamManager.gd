extends Node

const QuestionUIScene = preload("res://QuestionUI.tscn")

var all_questions = []
var current_question_index = 0
var score = 0

func _ready():
	var file = FileAccess.open("res://resource/math_001.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	
	if content:
		print("Sėkmingai įkeltas egzaminas", content.egzamino_pavadinimas)
		print("Klausimų kiekis: ", content.klausimai.size())
		all_questions = content.klausimai
		show_current_question()
	else:
		print("Klaida nuskaitant JSON failą.")

func show_current_question():
	if current_question_index < all_questions.size():
		var question_instance = QuestionUIScene.instantiate()
		
		var question_data = all_questions[current_question_index]
		question_instance.display_question(question_data)
		question_instance.answer_selected.connect(_on_user_answered.bind(question_instance))
		
		get_tree().current_scene.add_child(question_instance)

func _on_user_answered(user_answer, question_scene):
	var correct_answer = all_questions[current_question_index].atsakymas
	if user_answer == correct_answer:
		print("ATSAKYMAS TEISINGAS!")
		score += 1
	else:
		print("ATSAKYMAS NETEISINGAS. Teisingas atsakymas: ", correct_answer)
	
	question_scene.queue_free()
	current_question_index += 1
	
	if current_question_index < all_questions.size():
		show_current_question()
	else:
		#Once exam is finished
		print("--- Egzaminas Baigtas! ---")
		print("Galutinis rezultas: ", score, " iš ", all_questions.size())
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
	
