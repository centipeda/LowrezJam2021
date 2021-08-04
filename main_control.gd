extends Node2D

export(NodePath) var charge_timer_path
export(float) var hit_strength
export(NodePath) var charge_one_path
export(NodePath) var charge_two_path
export(NodePath) var charge_three_path

export(Color) var active_guide_color
export(Color) var inactive_guide_color

export(NodePath) var score_path

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
    "turner_r_pickup"
   ]

# Called when the node enters the scene tree for the first time.
func _ready():
    charge_timer = get_node(charge_timer_path)
    charge_nodes = [get_node(charge_one_path).get_child(0),
                    get_node(charge_two_path).get_child(0), 
                    get_node(charge_three_path).get_child(0)]
    score_node = get_node(score_path)

func _input(event):
    # check for mouse clicks
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


func _process(_delta):
    if charges > 0:
        guide_color = active_guide_color
    else:
        guide_color = inactive_guide_color
    score_node.text = str(score)
    if dying:
        $GuiRoot/DeathMeter.value = $ChargeTimer.time_left / $ChargeTimer.wait_time * 100
    update()

func _launch():
    if charges > 0:
        # set the charge bar with the last charge to 0
        charge_nodes[charges-1].value = 0
        # set the charging bar to 0
        if charges < max_charges:
            charge_nodes[charges].value = 0
        charges -= 1
        # apply an impulse to the ball in the direction of the mouse from the ball
        var _dir = (get_global_mouse_position() - $GolfBall.position).normalized()
        $GolfBall.apply_impulse(Vector2(), _dir*hit_strength)
    
        if charges == 0:
            start_death_countdown()

func _consume_pickup(pickup):
    print("consuming")
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
        charges += 1
        charge_nodes[charges-1].value = 100
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
    $GuiRoot/GameOver.visible = true
    get_tree().paused = true

func _on_ChargeTimer_timeout():
    game_over()

func _on_SpawnTimer_timeout():
    print($Pickups.get_child_count())
    $Pickups.add_pickup(pickup_types[randi() % len(pickup_types)])

func _on_pickup_entered(area):
    _consume_pickup(area)


func _on_RestartButton_pressed():
    get_tree().paused = false
    get_tree().reload_current_scene()
