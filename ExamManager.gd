extends Node

func _ready():
	var file = FileAccess.open("res://resource/math_001.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	
	if content:
		print("Sėkmingai įkeltas egzaminas", content.egzamino_pavadinimas)
		print("Klausimų kiekis: ", content.klausimai.size())
	else:
		print("Klaida nuskaitant JSON failą.")
