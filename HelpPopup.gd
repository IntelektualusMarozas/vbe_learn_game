extends PanelContainer

@onready var animation_player = $AnimationPlayer

func _ready():
	$VBoxContainer/CloseButton.pressed.connect(close)

func popup():
	self.visible = true
	animation_player.play("slide_in")

func close():
	animation_player.play("slide_out")
	await animation_player.animation_finished
	self.visible = false

func set_image(image_path):
	$VBoxContainer/ContentImage.texture = load(image_path)
	
