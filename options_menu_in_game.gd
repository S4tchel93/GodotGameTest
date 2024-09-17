extends Control


static var volume_db:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db = $"../OptionsMenu".get_master_volume()
	$MarginContainer/VBoxContainer/Volume/VolumeSlider.value = ((volume_db * 100 / 80)+100)
	$MarginContainer/VBoxContainer/Volume/VolumeSlider/VolumeLabel.text = str((volume_db * 100 / 80)+100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	$"..".pauseMenu()

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
	$"../OptionsMenu".set_master_volume(volume_db)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
