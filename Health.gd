extends HBoxContainer

signal no_health

export(int) var max_health
export(Color) var health_color
export(Color) var no_health_color

var health
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    health = max_health
    for child in get_children():
        child.color = health_color
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func lose_health():
    health -= 1
    get_child(health).color = no_health_color
    if health == 0:
        emit_signal("no_health")
