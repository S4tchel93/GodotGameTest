extends Control

static var volume_db:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/Volume/VolumeSlider.value = ((volume_db * 100 / 80)+100)
	$MarginContainer/VBoxContainer/Volume/VolumeSlider/VolumeLabel.text = str((volume_db * 100 / 80)+100)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

#TODO
func _on_video_button_pressed() -> void:
	pass # Replace with function body.

func _on_volume_slider_value_changed(value: float) -> void:
	volume_db = (value / 100 * 80)
	$MarginContainer/VBoxContainer/Volume/VolumeSlider/VolumeLabel.text = str(value+100)

func get_master_volume() -> float:
	return volume_db
