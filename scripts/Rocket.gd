extends RigidBody2D
signal hit

export var speed = 500

var screen_size
var start_pos
var reset_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):	
		angular_velocity += 0.1
	if Input.is_action_pressed("move_left"):
		angular_velocity -= 0.1
		
	if(velocity.y == 0):
		$AnimatedSprite.play("off")
	else:
		$AnimatedSprite.play("on")
		
	rotation += angular_velocity * delta
	apply_central_impulse(velocity.rotated(rotation) * speed * delta)
	
# position gets reset in _integrate forces because the transform of a Rigidbody cannot be alterned normally
func _integrate_forces(state):
	# implement screen wrap
	if position.x <= 0:
		state.transform = Transform2D(0.0, Vector2(screen_size.x + 10, position.y))
	elif position.x >= screen_size.x:
		state.transform = Transform2D(0.0, Vector2(10, position.y))
	elif position.y <= 0:
		state.transform = Transform2D(0.0, Vector2(position.x, screen_size.y - 10))
	elif position.y >= screen_size.y:
		state.transform = Transform2D(0.0, Vector2(position.x, 10))
	
	if reset_state:
		state.transform = Transform2D(0.0, start_pos)
		linear_velocity = Vector2.ZERO
		reset_state = false


# IMPORTANT: Make sure that Contact Monitor is on and that Contacts Reported is over 0 or else this 
func _on_RigidBody2D_body_entered(_body):
	emit_signal("hit")
	
	hide()
	
	# must used set_deferred because cannot set physics properties on physics callback
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	print(pos)
	start_pos = pos
	
	reset_state = true
	$CollisionShape2D.disabled = false
	
	show()
