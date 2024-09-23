extends Area2D

#Signal to notify that a mob was hit by the nuke
signal nuke_hit_mob()

func _ready():
	#instantiate a nuke
	$CollisionShape2D.disabled = false
	var screen_size = get_viewport_rect().size
	#Set position as center of whatever resolution is configured
	position.x = screen_size.x / 2 
	position.y = screen_size.y / 2
	$NukeDuration.start()
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		#Emit signal to notify to main.gd that a mob was hit by the nuke
		emit_signal("nuke_hit_mob")
		#Delete instance of the mob we just hit
		body.queue_free()

func _on_nuke_duration_timeout() -> void:
	#After nuke timer duration expires, delete nuke
	$NukeDuration.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
