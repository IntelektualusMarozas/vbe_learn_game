extends Node

const QuestionUIScene = preload("res://QuestionUI.tscn")

var all_questions = []
var current_question_index = 0
var results = []
var question_start_time = 0

func _ready():
	pass

func start_exam():
	current_question_index = 0
	results.clear()
	
	get_tree().change_scene_to_file("res://ExamPage.tscn")
	await get_tree().tree_changed
	
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
	
	question_start_time = Time.get_ticks_msec()

	var question_instance = QuestionUIScene.instantiate()
	var question_data = all_questions[current_question_index]
	question_instance.display_question(question_data)
	question_instance.answer_selected.connect(_on_user_answered.bind(question_instance))
	
	get_tree().current_scene.add_child(question_instance)

func _on_user_answered(user_answer, question_scene):
	var time_taken = (Time.get_ticks_msec() - question_start_time) / 1000.0
	
	var correct_answer = all_questions[current_question_index].atsakymas
	var is_correct = false
	
	if typeof(user_answer) == TYPE_ARRAY:
		user_answer.sort()
		correct_answer.sort()
		if user_answer == correct_answer:
			is_correct = true
	else:
		if user_answer == correct_answer:
			is_correct = true
			#TO DO: nature of such open question could be complex to implement. 
			#Need to think about the ways how to implement properly
	
	if is_correct:
		print("ATSAKYMAS TEISINGAS!")
		#score += 1
	else:
		print("ATSAKYMAS NETEISINGAS. Teisingas atsakymas: ", correct_answer)
	
	results.append({
		"id": all_questions[current_question_index].id,
		"is_correct": is_correct,
		"time_taken": time_taken
	})
	
	question_scene.queue_free()
	current_question_index += 1
	
	if current_question_index < all_questions.size():
		show_current_question()
	else:
		#Once exam is finished
		display_final_results()

func display_final_results():
	print("--- Egzaminas Baigtas! ---")
	
	var final_score = 0
	var difficult_questions = []
	
	for result in results:
		if result.is_correct:
			final_score += 1
		else:
			difficult_questions.append(result.id)
			
		print("Klausimas: %s, Teisingai: %s, Laikas: %.2f sek." % [result.id, result.is_correct, result.time_taken])
		
	print("\nGalutinis rezultatas: %d iš %d" % [final_score, all_questions.size()])
	
	if not difficult_questions.is_empty():
		print("Sunkūs klausimai (reikėtų pakartoti): ", difficult_questions)
	else:
		print("Sveikiname! Visi atsakymai teisingi!")
	
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	#get_tree().quit()
