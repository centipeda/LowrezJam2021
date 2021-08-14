extends Node2D

export(NodePath) var charge_timer_path
export(float) var hit_strength
export(NodePath) var charge_one_path
export(NodePath) var charge_two_path
export(NodePath) var charge_three_path

export(Color) var active_guide_color
export(Color) var inactive_guide_color
export(float) var max_probability = 0

export(NodePath) var score_path

export(float) var marsh_deceleration

var clicked = false
var dying = false
var max_charges = 3
var charges = 3
var charge_nodes
var charge_timer
var guide_color
var score = 0
var score_node
var pickup_types = [
	"basic_pickup",
	"booster_pickup",
	"turner_l_pickup",
	"turner_r_pickup",
	"danger_pickup",
	"max_pickup"
   ]
var pickup_drop_rarities = [
	25,
	20,
	20,
	20,
	15,
	5,
]
var cumulative_pickup_rarities = Array()

var pickup_drop_chances

var active_level = 0
var levels = [
	"FireTemple",
	"DesertLevel",
	"GrassLevel",
	"IceLevel",
	"CPUTemple",
	"WindowTemple"
   ]

# Called when the node enters the scene tree for the first time.
func _ready():
	var last_rarity = 0
	for n in range(0, pickup_drop_rarities.size()):
		cumulative_pickup_rarities.append(pickup_drop_rarities[n] + last_rarity)
		last_rarity = cumulative_pickup_rarities[n]
		
	if max_probability == 0:
		max_probability = sum_array(pickup_drop_rarities)
		
	charge_timer = get_node(charge_timer_path)
	charge_nodes = [get_node(charge_one_path).get_child(0),
					get_node(charge_two_path).get_child(0), 
					get_node(charge_three_path).get_child(0)]
	score_node = get_node(score_path)
	
	
	#Play music corresponding to level
	if(active_level == 0):
		$Music/FireThemeRetro.play()
	elif(active_level == 1):
		$Music/DesertThemeRetro.play()
	elif(active_level == 2):
		$Music/GrassThemeRetro.play()
	elif(active_level == 3):
		$Music/IceThemeRetro.play()
	elif(active_level == 4):
		$Music/FireThemeRetro.play()
	elif(active_level == 5):
		$Music/FireThemeRetro.play()

func sum_array(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum

func choose_pickup():
	var pickup_type = 0
	var randomValue = int(rand_range(0, max_probability))
	while (cumulative_pickup_rarities[pickup_type] <= randomValue):
		pickup_type += 1
	return pickup_type

func _input(event):
	# check for mouse clicks...
	# if we clicked and released then launch the ball
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				clicked = true
			else:
				_launch()
				clicked = false
	elif event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			game_over()

func _draw():
	# draw the launch guideline if the left mouse button is down
	if clicked:
		var endpoint = $GolfBall.position.move_toward(get_global_mouse_position(), 16)
		#var p1 = Vector2(endpoint.x,endpoint.y).move_toward($GolfBall.position, 3).rotated(deg2rad(-45))
		#var p2 = Vector2(endpoint.x,endpoint.y).move_toward($GolfBall.position, 3).rotated(deg2rad(45))
		draw_line(endpoint, $GolfBall.position, guide_color, 2)
		#draw_polygon([endpoint, p1, p2], [guide_color, guide_color, guide_color])
	# draw the golf ball
	draw_circle($GolfBall.position.round(), 3, Color.white)
 

func _process(delta):
	if charges > 0:
		guide_color = active_guide_color
	else:
		guide_color = inactive_guide_color
	score_node.text = str(score)
	if dying:
		$GuiRoot/DeathMeter.value = $ChargeTimer.time_left / $ChargeTimer.wait_time * 100
	
	# if we're on the grass level
	if $GrassLevel.visible:
		# decelerate ball while it's in the "marsh"
		if $GrassLevel/Colliders.overlaps_body($GolfBall):
			var opposing_force = $GolfBall.linear_velocity.normalized().rotated(rad2deg(180))
			$GolfBall.add_force(Vector2(), opposing_force*marsh_deceleration)
	update()



func load_level(load_level_idx):
	var level
	# cycle through all the nodes representing each level
	for level_idx in range(levels.size()):
		level = get_node(levels[level_idx])
		# if it's the level we want, make it visible
		level.visible = (level_idx == load_level_idx)
		# then activate all of its colliders by settind disabled to false
		for collider in level.get_node("Colliders").get_children():
			collider.disabled = (level_idx != load_level_idx)
	# set the active level so we know which high score to update
	active_level = load_level_idx

func deplete_charge():
	# set the charge bar with the last charge to 0
	charge_nodes[charges-1].value = 0
		# set the charging bar to 0
	if charges < max_charges:
		charge_nodes[charges].value = 0
	charges -= 1
	
	if charges == 0:
			start_death_countdown()

func _launch():
	if charges > 0:
		deplete_charge()
		# apply an impulse to the ball in the direction of the mouse from the ball
		var _dir = (get_global_mouse_position() - $GolfBall.position).normalized()
		$GolfBall.apply_impulse(Vector2(), _dir*hit_strength)
	elif dying:
		var _dir = (get_global_mouse_position() - $GolfBall.position).normalized()
		$GolfBall.apply_impulse(Vector2(), _dir*hit_strength*1.5)


func _consume_pickup(pickup):
	print("consuming")
	
	if pickup.is_in_group("danger_pickup"):
		$GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*200)
		$GolfBall.linear_velocity = $GolfBall.linear_velocity.rotated(deg2rad(randi() % 360))
		
		pickup.queue_free()
		if charges > 0:
			deplete_charge()
		elif dying:
			game_over()
		$GolfBall.linear_velocity = $GolfBall.linear_velocity.rotated(deg2rad(90))
		$GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*25)
	
	elif pickup.is_in_group("max_pickup"):
		max_out_charges()
		pickup.queue_free()
		score += 5
	else:
		if pickup.is_in_group("booster_pickup"):
			$GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*100)
		elif pickup.is_in_group("turner_l_pickup"):
			$GolfBall.linear_velocity = $GolfBall.linear_velocity.rotated(deg2rad(-90))
			$GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*25)
		elif pickup.is_in_group("turner_r_pickup"):
			$GolfBall.linear_velocity = $GolfBall.linear_velocity.rotated(deg2rad(90))
			$GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*25)
		
		pickup.queue_free()
		score += 1
		
		if charges < max_charges:
			add_charge()

func add_charge():
	charges += 1
	charge_nodes[charges-1].value = 100
	if dying:
		stop_death_countdown()

func max_out_charges():
	charges = max_charges
	for n in range(0, max_charges):
		charge_nodes[n].value = 100
	if dying:
		stop_death_countdown()

func start_death_countdown():
	$ChargeTimer.start()
	$GuiRoot/DeathMeter.visible = true
	dying = true

func stop_death_countdown():
	$ChargeTimer.stop()
	$GuiRoot/DeathMeter.visible = false
	dying = false
	
func game_over():
	var high_score = int($SaveData.data["high_scores"][active_level])
	# check if we have new level high score
	$GuiRoot/GameOver.visible = true
	$GuiRoot/GameOver/Score.text = "score: " + str(score)
	# update data if we got a new high score
	if score > high_score:
		$SaveData.data["high_scores"][active_level] = score
		$SaveData.save_data()
		$GuiRoot/GameOver/HighScore.text = "new high score!"
	# otherwise just show the old high score
	else:
		$GuiRoot/GameOver/HighScore.text = "high score: " + str(high_score)
	# check if we unlocked a new level
	if active_level < levels.size()-1 and \
	   score > $SaveData.unlock_thresholds[active_level] and \
	   not $SaveData.data["unlocked"][active_level+1]:
		$SaveData.data["unlocked"][active_level+1] = true
		$SaveData.save_data()
	else:
		$GuiRoot/GameOver/LevelUnlocked.visible = false
	get_tree().paused = true

func _on_ChargeTimer_timeout():
	game_over()

func _on_SpawnTimer_timeout():
	print($Pickups.get_child_count())
	var pickup_to_choose = choose_pickup()
	$Pickups.add_pickup(pickup_types[pickup_to_choose])
	
func _on_EnemyTimer_timeout():
	$Pickups.count()
	#$Pickups.add_enemy(pickup_types[4], 31, 31, 8, 0)
	#$Pickups.spiral_movement()
	if(active_level == 0):
		$Pickups.stage1_movement()
	elif(active_level == 1):
		$Pickups.stage2_movement()
	elif(active_level == 2):
		$Pickups.stage3_movement()
	elif(active_level == 3):
		$Pickups.stage4_movement()
	
func _on_pickup_entered(area):
	_consume_pickup(area)


func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

# determine how the teleporters function
func _on_Teleporters_body_entered(body):
	# determine which teleporter was entered
	if body.is_in_group("player"):
		if body.position.x < 16 and body.position.y > 48:
			$FireTemple/Colliders/TeleporterBL/TeleportParticles.emitting = true
		elif body.position.x > 48 and body.position.y > 48:
			$FireTemple/Colliders/TeleporterBR/TeleportParticles.emitting = true
		elif body.position.x > 48 and body.position.y < 16:
			$FireTemple/Colliders/TeleporterTR/TeleportParticles.emitting = true
		elif body.position.x < 16 and body.position.y < 16:
			$FireTemple/Colliders/TeleporterTL/TeleportParticles.emitting = true
		# tell ball to teleport itself to the center
		$GolfBall.teleport_to($GolfBall.TELEPORT_TO.CENTER)
