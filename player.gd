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
var lastDirection = Vector2(1.0, 0.0) #Normalized Right Horizontal direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size #Get Screen Size
	hide()

# Function that sets up the player when the game starts, called by main
func start():
	#Set position as center of whatever resolution is configured
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	show()
	#Enable colission at start of game
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	#TODO: change this to a "match" statement instead of "if"
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
		
	#Calculate actual movement velocity based on normalized vector values "-1, 0, 1"
	#and the speed factor and play. Also decide if an animation shall be played
	if velocity.length() > 0:
		lastDirection = velocity
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#Get new position for this frame based on previous position and
	#movement velocity
	position += velocity * delta
	#Clamp position to the bounds of the screen_size resolution so the player
	#doesn't go out of bounds
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#Decide animation to play based on normalized vectors
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false;
		# If normalized vector is negative, flip the sprite horizontally
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		# If normalized vector is positive, flip the sprite vertically
		$AnimatedSprite2D.flip_v = velocity.y > 0

# Function that's executed whenever the player touches something else that has collision
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		#If we touched a mob, it's game over, emit "hit signal" and hide player
		hide()
		hit.emit()
		#Disable player colission
		$CollisionShape2D.set_deferred("disabled", true)

# Function that emits a signal to other modules when shooting action is performed
func shoot():
	if (canShoot && visible):
		emit_signal("pewpew", bullet_scene, lastDirection, global_position)

# Function that emits a signal to other modules when Nuke action is performed
func nuke():
	if (canShoot && visible):
		emit_signal("boom", nuke_scene, global_position)
