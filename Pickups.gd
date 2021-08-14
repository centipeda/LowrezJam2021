extends Node2D

signal pickup_entered(area)

export(PackedScene) var pickup_proto

#array of enemies
var spiral_enemies = []
#game length time count
var counter = 0
var mod = 0

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
	if counter > 80:
		counter = counter % 80
	if counter == 5:
		for i in 5:
			add_enemy("danger_pickup", 2+i*15, 1, 8, 270)
	if counter == 23:
		for i in 5:
			add_enemy("danger_pickup", 1, 2+i*15, 8, 180)
	elif counter > 35 and counter < 53  and counter%3 == 0:
		add_enemy("danger_pickup", 16, 5, 8, 270)
		add_enemy("danger_pickup", 44, 58, 8, 90)
	elif counter > 60 and counter < 79 and counter%2 == 0:
		add_enemy("danger_pickup", 5, 16, 8, 180)
		add_enemy("danger_pickup", 58, 44, 8, 0)
		
func stage2_movement():
	if counter > 93:
		counter = counter % 85
	if counter > 2 and counter < 23  and counter%2 == 0:
		add_enemy("danger_pickup", 31, 31, 6, (counter-4)*12)
	elif counter == 28:
		for i in 5:
			add_enemy("danger_pickup", 2+i*15, 1, 9, 270)
	elif counter > 34 and counter < 54 :
		add_enemy("danger_pickup", 31, 31, 6, -(counter-34)*16)
	elif counter > 60 and counter < 86:
		if counter < 84 and counter %2 == 0:
			add_enemy("danger_pickup", 31, 9, 7, 180)
		circle_movement()
		
func stage3_movement():
	if counter > 2 and counter < 15  and counter%2 == 0:
		add_enemy("danger_pickup", 16, 5, 5, 270)
		add_enemy("danger_pickup", 44, 58, 5, 90)
	elif counter > 19 and counter < 60:
		if counter < 37 and counter%2 == 0:
			add_enemy("danger_pickup", -9, 62, 7, 90)
		if counter < 40 and counter > 24 and counter%2 == 0:
			add_enemy("danger_pickup", 60, 18, 7, 0)
		circle_movement()
	elif counter > 58:
		if counter < 78:
			add_enemy("danger_pickup", 31, 12, 7, 180)
		circle_movement()
		
func stage4_movement():
	if counter > 73:
		counter = counter % 85
		mod = mod - 1
	knot_movement()
	if counter > 2 and counter % 2 == 0:
		if counter < 22:
			add_enemy("danger_pickup", 31, 31, 7 + mod, 0)
	if counter > 31 and counter % 2 == 0:
		if counter < 51:
			add_enemy("danger_pickup", 31, 31, 7 + mod, 90)
			
func stage5_movement():
	if counter > 97:
		counter = counter % 98
		mod = mod + 1
	if counter == 4:
		for i in 5:
			add_enemy("danger_pickup", 2+i*15, 1, 8, 270)
			add_enemy("danger_pickup", 2+i*15+3, 63, 8, 90)
	if counter > 18  and counter < 39:
		add_enemy("danger_pickup", 63, 63, 7.7+mod, (counter%10)*12)
	if counter > 50  and counter < 69:
		add_enemy("danger_pickup", 1, 1, 7.7+mod, (-(counter%10)*12)-52)
	if counter > 77 and counter < 92:
		circle_movement()
		add_enemy("danger_pickup", 22, 12, 7-mod, 180)
		add_enemy("danger_pickup", 40, 55, 7-mod, 0)
		
func stage6_movement():
	mod = 1.2
	if counter > 73:
		counter = counter % 85
	if counter > 2 and counter < 30 and counter % 2 == 0:
		add_enemy("danger_pickup", 31, 31, 8, (counter-4)*14)
		add_enemy("danger_pickup", 31, 31, 8, 180 +(counter-4)*14)
	if counter == 35:
		for i in 5:
			add_enemy("danger_pickup", 2+i*15, 1, 8, 270)
			add_enemy("danger_pickup", 4+i*15, 63, 8, 90)
			add_enemy("danger_pickup", 1, 4+i*15, 8, 180)
			add_enemy("danger_pickup", 63, 2+i*15, 8, 0)
	if counter > 44:
		knot_movement()
		if counter < 60 and counter%2 == 0:
			add_enemy("danger_pickup", 31, 31, 7 + mod, 270)
			add_enemy("danger_pickup", 31, 31, 7 + mod, 90)

func circle_movement():
	for i in spiral_enemies.size():
		if(is_instance_valid(spiral_enemies[i])):
			spiral_enemies[i].velocity = spiral_enemies[i].velocity.rotated(deg2rad(8))

func flower_movement():
	for i in spiral_enemies.size():
		if(is_instance_valid(spiral_enemies[i])):
			spiral_enemies[i].velocity = spiral_enemies[i].velocity.rotated(deg2rad((counter%10)*3))

func spiral_movement():
	if counter < 45:
		add_enemy("danger_pickup", 31, 31, 5, counter*6)

func knot_movement():
	for i in spiral_enemies.size():
		if(is_instance_valid(spiral_enemies[i])):
			var mltplr = spiral_enemies[i].position.distance_to(Vector2(31,31))*.14
			spiral_enemies[i].velocity = spiral_enemies[i].velocity.rotated(deg2rad((2.9 + mod)*mltplr))

func count():
	counter = counter + 1
