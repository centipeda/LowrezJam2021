extends Area2D

signal pickup_entered(area)

var color = Color.white

# Called when the node enters the scene tree for the first time.
func _ready():
    # connect this scene to its parent so it can signal the main scene...
    # this seems somehow hacky, but I can't figure a better way to do it
    connect("pickup_entered", get_parent(), "_on_pickup_body_entered")
    if is_in_group("booster_pickup"):
        color = Color.red
    elif is_in_group("turner_r_pickup"):
        color = Color.blue
    elif is_in_group("turner_l_pickup"):
        color = Color.green

func _process(_delta):
    update()

func _draw():
    draw_circle(Vector2(), 2, color)

# detect when we've been collided with
func _on_Pickup_body_entered(body):
    emit_signal("pickup_entered", self)
