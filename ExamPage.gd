extends VBoxContainer

@onready var feedback_label = $FeedbackLabel
@onready var feedback_timer = $FeedbackTimer
@onready var help_button = $HelpButton
@onready var help_popup = $HelpPopup

func _ready():
	# Connect to the ExamManager's signal when the page loads
	help_button.pressed.connect(_on_help_button_pressed)
	ExamManager.feedback_provided.connect(_on_feedback_provided)
	feedback_timer.timeout.connect(_on_feedback_timer_timeout)

func _on_feedback_provided(message, is_correct):
	feedback_label.text = message
	
	if is_correct:
		feedback_label.modulate = Color.GREEN
	else:
		feedback_label.modulate = Color.RED
		
	# Show the label and start the timer to hide it after a delay
	feedback_label.show()
	feedback_timer.start()

func _on_feedback_timer_timeout():
	# Hide the label when the timer finishes
	feedback_label.hide()

func _on_help_button_pressed():
	print("DOCS button pressed")
	help_popup.set_image("res://images/formulės_1.jpg")
	help_popup.popup()
