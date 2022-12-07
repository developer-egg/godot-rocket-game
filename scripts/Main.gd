extends Node

export (PackedScene) var asteroid_scene
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# this function makes new random numbers be generated every time, think a seed from minecraft
	randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func game_over():
	$AsteroidTimer.stop()
	$ScoreTimer.stop()
	
	$HUD.show_game_over()
	
	# clear all asteroids
	get_tree().call_group("asteroids", "queue_free")
	
func start():
	score = 0
	$HUD.update_score(score)
	$HUD.initial_start()
	$StartTimer.start()


func _on_StartTimer_timeout():
	$AsteroidTimer.start()
	$ScoreTimer.start()
	$Rocket.start($StartPosition.position)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_AsteroidTimer_timeout():
	var asteriod = asteroid_scene.instance()
	
	# choose a random location on the asteroid path
	var asteroid_spawn_location = get_node("AsteroidPath/AsteroidSpawnLocation")
	asteroid_spawn_location.offset = randi()
	
	asteriod.position = asteroid_spawn_location.position
	
	# set the direction perpendicular to the path
	var direction = asteroid_spawn_location.rotation + PI / 2
	
	# add randomness to the direction
	direction +=  rand_range(-PI / 4, PI / 4)
	asteriod.rotation = direction
	
	# set the velocity of the asteroid
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	asteriod.linear_velocity = velocity.rotated(direction)
	
	# set a random gravity scale
	asteriod.gravity_scale = rand_range(-2, 2)
	
	# spawn the asteroid
	add_child(asteriod)
	

func _on_HUD_start_game():
	start()
	
	
func _on_Rocket_hit():
	game_over()
