extends Area2D
signal enemy_hit
signal projectile_enemy_hit

@export var SPEED = 400
@export var SPAWN_TIME = 3

var direction : Vector2

func _ready():
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
		#Emit signal to be handled by main.gd
		projectile_enemy_hit.emit()
		#Emit signal that we just hit a mob
		enemy_hit.emit()

#Executes when enemy_hit is signaled
func _on_enemy_hit() -> void:
	#Delete projectile instance
	queue_free()
