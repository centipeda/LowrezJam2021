extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum TELEPORT_TO { NONE, CENTER, TL, TR, BL, BR }
var teleport_state = TELEPORT_TO.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# to implement teleporters, we need to alter the physics of the ball directly
# which we can only do in the integrate forces function
func _integrate_forces(state):
    match teleport_state:
        TELEPORT_TO.CENTER:
            state.transform = Transform2D(rotation, Vector2(32,32))
            teleport_state = TELEPORT_TO.NONE

func teleport_to(teleport_loc):
    teleport_state = teleport_loc

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
