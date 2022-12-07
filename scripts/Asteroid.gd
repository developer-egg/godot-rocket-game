extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	var animation_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = animation_types[randi() % animation_types.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_VisibilityNotifier2D_screen_exited():
	# destroy asteroid when it leaves the screen
	queue_free()
