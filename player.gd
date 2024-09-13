extends Area2D
signal hit
signal pewpew(projectile,direction,pos)
signal boom(nuke,pos)

@export var speed = 400
@export var bullet_scene: PackedScene
@export var nuke_scene: PackedScene
@export var shootSpeed = 1.0

var screen_size
var canShoot = true
var lastDirection = Vector2(1.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size #Get Screen Size
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("nuke"):
		nuke()
		
	if velocity.length() > 0:
		lastDirection = velocity
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false;
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)

func shoot():
	if (canShoot && visible):
		$shoot.play()
		emit_signal("pewpew", bullet_scene, lastDirection, global_position)

func nuke():
	if (canShoot && visible):
		emit_signal("boom", nuke_scene, global_position)
