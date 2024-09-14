extends CanvasLayer

signal start_game
const RED 	= Color(0xFF,0,0,0xFF)
const WHITE = Color(0xFF,0xFF,0xFF,0xFF)
static var color_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NukeNotif.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until MessageTimer has counted down
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	#Make a One-Shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()

func set_nuke_notif(nukeAvailable):
	if(nukeAvailable):
		$NukeNotif.show()
		$NukePulseTimer.start()
	else:
		$NukeNotif.hide()
		$NukePulseTimer.stop()

func _on_nuke_pulse_timer_timeout() -> void:
	var nuke_label_array = [WHITE, RED]
	
	#Change color of label
	$NukeNotif.add_theme_color_override("font_color", nuke_label_array[color_index])
	#Alternate color for next cycle
	if(color_index == 1):
		color_index = 0
	else:
		color_index = 1
