extends Node2D

@onready var feedback_label = $FeedbackLabel
@onready var feedback_timer = $FeedbackTimer

func _ready():
	ExamManager.feedback_provided.connect(_on_feedback_provided)
	feedback_timer.timeout.connect(_on_feedback_timer_timeout)
	
func _on_feedback_provided(message, is_correct):
	feedback_label.text = message
	
	if is_correct:
		feedback_label.modulate = Color.GREEN
	else:
		feedback_label.modulate = Color.DARK_RED
	
	feedback_label.show()
	feedback_timer.start()
	
func _on_feedback_timer_timeout():
	feedback_label.hide()
