extends Node2D

signal pickup_entered(area)

export(PackedScene) var pickup_proto

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
 
func _process(_delta):
    pass
        
func add_pickup(pickup_type):
    # spawn a pickup
    var p = pickup_proto.instance()
    p.add_to_group(pickup_type)
    # select the pickup's move speed
    var speed = randi() % 10 + 10
    # pick a point near the center of the field for the moving pickup to "aim" at
    var target = Vector2(randi() % 16 + 32, randi() % 16 + 32)
    # pick a direction for the pickup to come in from
    var rotation = randi() % 360
    # calculate the start position of the pickup from the target and direction
    p.position = Vector2(1,0).rotated(deg2rad(rotation))*64 + target
    # as well as the velocity
    p.velocity = Vector2(1,0).rotated(deg2rad(rotation+180))*speed
    add_child(p)
    # p.connect_parent()

func _on_pickup_body_entered(area):
    emit_signal("pickup_entered", area)
