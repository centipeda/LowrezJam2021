extends Area2D

signal pickup_entered(area)

var color = Color.white
var velocity = Vector2()
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_parent()
	# the effect of the pickup (and its color) is determined by which tag
	# the pickup has on it
	if is_in_group("booster_pickup"):
		color = Color.red
	elif is_in_group("turner_r_pickup"):
		color = Color.blue
	elif is_in_group("turner_l_pickup"):
		color = Color.green
	elif is_in_group("max_pickup"):
		color = Color.gold
	elif is_in_group("danger_pickup"):
		color = Color.black
	$DeathParticles.color = color

func _process(delta):
	position = position + velocity * delta
	if position.x < -48 or position.x > 64+48 or \
	   position.y < -48 or position.y > 64+48:
		queue_free()
	if dead and not $DeathParticles.emitting:
		queue_free()
	update()

func _draw():
	if not dead:
		draw_circle(Vector2(), 2, color)

# detect when we've been collided with
func _on_Pickup_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("pickup_entered", self)

func connect_parent():
	# connect this scene to its parent so it can signal the main scene...
	# this seems somehow hacky, but I can't figure a better way to do it
	connect("pickup_entered", get_parent(), "_on_pickup_body_entered")

func consume():
	$DeathParticles.emitting = true
	dead = true
