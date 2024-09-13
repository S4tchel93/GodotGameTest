extends Area2D
signal enemy_hit

@export var SPEED = 400
@export var SPAWN_TIME = 3

var direction : Vector2

func _ready():
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(SPAWN_TIME).timeout
	position = global_position

func set_direction(bulletDirection):
	direction = bulletDirection

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		#Delete instance of the mob we just hit
		body.queue_free()
		#Emit signal that we just hit a mob
		enemy_hit.emit()

#Executes when enemy_hit is signaled
func _on_enemy_hit() -> void:
	#Play explosion sound when hitting an enemy
	$Explosion.play()
	#Disable collision so we only destroy one enemy with one projectile
	$CollisionShape2D.set_deferred("disabled", true)
	#Hide projectile as soon as it hits an enemy
	hide()
	#Wait for explosion sound to finish
	await $Explosion.finished == true
	#Delete projectile instance
	queue_free()
