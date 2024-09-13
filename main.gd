extends Node

@export var mob_scene: PackedScene
var mob
var score
var difficulty = 0.0;
var nukeAvailable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	difficulty = 0
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range((150.0 + difficulty), (250.0 + difficulty)), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	#Set difficulty (mob speed) up every 15 score points
	if(score % 15 == 0 && score > 0):
		difficulty += 100.0
		print("current difficulty: " + str(difficulty/100.0))
	#Set Nuke Available after player gets sums up a 20 score
	if(score % 20 == 0 && score > 0 && nukeAvailable == false):
		nukeAvailable = true
		$HUD.set_nuke_notif(nukeAvailable)
		print("Nuke Available: " + str(nukeAvailable))

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_player_pewpew(projectile: Variant, direction: Variant, pos: Variant) -> void:
	var bullet = projectile.instantiate()
	bullet.set_direction(direction)
	bullet.position = pos
	add_child(bullet)

func _on_player_boom(nuke: Variant, pos: Variant) -> void:
	if(nukeAvailable):
		$NukeBeam.play()
		nukeAvailable = false
		$HUD.set_nuke_notif(nukeAvailable)
		var special_bomb = nuke.instantiate()
		add_child(special_bomb)
