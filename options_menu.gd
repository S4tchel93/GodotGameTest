extends Control

# Signal emitted when the aim type is changed
signal aim_type_changed(control_type)
# Master volume for game
# -28 dB is equal to 65% volume
static var volume_db:float = -28.0
# Aim type (True = Mouse Aim / False = Keyboard Aim)
static var aim_type:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/Volume/VolumeSlider.value = ((volume_db * 100 / 80)+100)
	$MarginContainer/VBoxContainer/Volume/VolumeSlider/VolumeLabel.text = str((volume_db * 100 / 80)+100)
	# Setting default aim type text (Keyboard Aim)
	set_aim_type_label_text(aim_type)

func _on_back_button_pressed() -> void:
	if $"..".get_game_started():
		$"..".pauseMenu()
	else:
		get_tree().change_scene_to_file("res://main.tscn")

#TODO
func _on_video_button_pressed() -> void:
	pass # Replace with function body.

func _on_volume_slider_value_changed(value: float) -> void:
	volume_db = (value / 100 * 80)
	$MarginContainer/VBoxContainer/Volume/VolumeSlider/VolumeLabel.text = str(value+100)
	$"../../Music".volume_db = volume_db
	$"../../DeathSound".volume_db = volume_db
	$"../../NukeBeam".volume_db = volume_db
	$"../../shoot".volume_db = volume_db
	# Adding a negative offset to explosion, since it's too loud
	$"../../Explosion".volume_db = -9.0 + volume_db

func get_master_volume() -> float:
	return volume_db

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Called when the aim tppe button is toggled
# @param toggled_on: bool
func _on_aim_type_button_toggled(toggled_on: bool) -> void:
	aim_type = toggled_on
	# Set the aim type label text 
	set_aim_type_label_text(aim_type)
	# Emit signal to notify to main.gd the change in aim type 
	emit_signal("aim_type_changed", aim_type)

# Sets the aim type label text based on button state
# True = Mouse Aim / False = Keyboard Aim
# @param toggled_on: bool
func set_aim_type_label_text(toggled_on: bool) -> void:
	if(toggled_on):
		$MarginContainer/VBoxContainer/Controls/AimTypeLabel.text = "Mouse Aim"
	else:
		$MarginContainer/VBoxContainer/Controls/AimTypeLabel.text = "Keyboard Aim"

# Returns the current aim type
func get_aim_type() -> bool:
	return aim_type
