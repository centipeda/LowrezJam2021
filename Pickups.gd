extends Node2D

signal pickup_entered(area)

export(PackedScene) var pickup_proto

#array of enemies
var spiral_enemies = []
#game length time count
var counter = 0

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
	
	
# ENEMY MOVEMENT SECTION
func add_enemy(pickup_type, x, y, speed, rotation):
	# spawn a spiral of enemies
	var p = pickup_proto.instance()
	p.add_to_group(pickup_type)
	# select the pickup's move speed
	print("speed: ", speed)
	# calculate the start position of the pickup from the target and direction
	p.position = Vector2(x,y)
	print("position: ", p.position)
	# as well as the velocity
	p.velocity = Vector2(1,0).rotated(deg2rad(rotation+180))*speed
	print("velocity: ", p.velocity)
	spiral_enemies.push_back(p)
	add_child(p)
	p.connect_parent()
	

func stage1_movement():
	if counter == 5:
		for i in 5:
			add_enemy("danger_pickup", 2+i*15, 1, 5, 270)
	if counter == 12:
		for i in 5:
			add_enemy("danger_pickup", 1, 2+i*15, 5, 180)
	elif counter > 25 and counter < 42  and counter%3 == 0:
		add_enemy("danger_pickup", 16, 5, 5, 270)
		add_enemy("danger_pickup", 44, 58, 5, 90)
	elif counter > 42 and counter < 60 and counter%2 == 0:
		add_enemy("danger_pickup", 5, 16, 5, 180)
		add_enemy("danger_pickup", 58, 44, 5, 0)
		
func stage2_movement():
	if counter > 2 and counter < 23  and counter%2 == 0:
		add_enemy("danger_pickup", 31, 31, 6, (counter-4)*12)
	elif counter == 23:
		for i in 5:
			add_enemy("danger_pickup", 2+i*15, 1, 7, 270)
	elif counter > 29 and counter < 50 :
		add_enemy("danger_pickup", 31, 31, 6, -(counter-29)*16)
	elif counter > 58:
		if counter < 78:
			add_enemy("danger_pickup", 31, 12, 7, 180)
		circle_movement()
		
func stage3_movement():
	if counter > 2 and counter < 17  and counter%2 == 0:
		add_enemy("danger_pickup", 16, 5, 5, 270)
		add_enemy("danger_pickup", 44, 58, 5, 90)
	elif counter > 19 and counter < 50:
		if counter < 40:
			add_enemy("danger_pickup", 60, 12, 7, 0)
			add_enemy("danger_pickup", 4, 52, 7, 90)
		circle_movement()
	elif counter > 29 and counter < 50 :
		add_enemy("danger_pickup", 31, 31, 6, -(counter-29)*16)
	elif counter > 58:
		if counter < 78:
			add_enemy("danger_pickup", 31, 12, 7, 180)
		circle_movement()
		
func stage4_movement():
	knot_movement()
	if counter > 2:
		if counter < 15:
			add_enemy("danger_pickup", 31, 31, 7, 0)
	if counter > 29:
		if counter < 42:
			add_enemy("danger_pickup", 31, 31, 7, 90)

func circle_movement():
	for i in spiral_enemies.size():
		if(is_instance_valid(spiral_enemies[i])):
			spiral_enemies[i].velocity = spiral_enemies[i].velocity.rotated(deg2rad(15))

func flower_movement():
	for i in spiral_enemies.size():
		if(is_instance_valid(spiral_enemies[i])):
			spiral_enemies[i].velocity = spiral_enemies[i].velocity.rotated(deg2rad((counter%10)*9))

func spiral_movement():
	if counter < 45:
		add_enemy("danger_pickup", 31, 31, 5, counter*12)

func knot_movement():
	for i in spiral_enemies.size():
		if(is_instance_valid(spiral_enemies[i])):
			var mltplr = spiral_enemies[i].position.distance_to(Vector2(31,31))*.14
			spiral_enemies[i].velocity = spiral_enemies[i].velocity.rotated(deg2rad(5.8*mltplr))

func count():
	counter = counter + 1
