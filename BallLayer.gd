extends Node2D

export(float) var hit_strength
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _process(delta):
    update()

func _draw():
    draw_circle($Ball.position.round(), 3, Color.white)

func _input(event):
    # check for mouse clicks...
    # if we clicked and released then launch the ball
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if not event.pressed:
                _launch()

func _launch():
    var _dir = (get_global_mouse_position() - $Ball.position).normalized()
    $Ball.apply_impulse(Vector2(), _dir*hit_strength)
