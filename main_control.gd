extends Node2D

export(NodePath) var charge_timer_path
export(float) var hit_strength
export(NodePath) var charge_one_path
export(NodePath) var charge_two_path
export(NodePath) var charge_three_path

export(Color) var active_guide_color
export(Color) var inactive_guide_color

var clicked = false
var max_charges = 3
var charges = 3
var charge_nodes
var charge_timer
var guide_color

# Called when the node enters the scene tree for the first time.
func _ready():
    charge_timer = get_node(charge_timer_path)
    charge_nodes = [get_node(charge_one_path).get_child(0),
                    get_node(charge_two_path).get_child(0), 
                    get_node(charge_three_path).get_child(0)]

func _input(event):
    # check for mouse clicks
    # if we clicked and released then launch the ball
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if event.pressed:
                print("left click")
                clicked = true
            else:
                print("left unclick")
                _launch()
                clicked = false

func _draw():
    # draw the launch guideline if the left mouse button is down
    if clicked:
        draw_line($GolfBall.position + (get_global_mouse_position() - $GolfBall.position).normalized()*16,
                  $GolfBall.position, guide_color, 2)
    # draw the golf ball
    draw_circle($GolfBall.position.round(), 3, Color.white)


func _process(_delta):
    if charges > 0:
        guide_color = active_guide_color
    else:
        guide_color = inactive_guide_color
    if charges < max_charges:
        var _charge_progress = (charge_timer.wait_time - charge_timer.time_left) / charge_timer.wait_time * 100
        charge_nodes[charges].value = _charge_progress
    update()

func _launch():
    if charges > 0:
        charge_timer.paused = true
        # set the charge bar with the last charge to 0
        charge_nodes[charges-1].value = 0
        # set the charging bar to 0
        if charges < max_charges:
            charge_nodes[charges].value = 0
        charges -= 1
        # reset the timer for the charge
        charge_timer.paused = false
        if charge_timer.is_stopped():
            charge_timer.start()
        # apply an impulse to the ball in the direction of the mouse from the ball
        var _dir = (get_global_mouse_position() - $GolfBall.position).normalized()
        $GolfBall.apply_impulse(Vector2(), _dir*hit_strength)

func _consume_pickup(pickup):
    print("consuming")
    if pickup.is_in_group("booster_pickup"):
        $GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*50)
    elif pickup.is_in_group("turner_l_pickup"):
        $GolfBall.linear_velocity = $GolfBall.linear_velocity.rotated(deg2rad(-90))
        $GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*25)
    elif pickup.is_in_group("turner_r_pickup"):
        $GolfBall.linear_velocity = $GolfBall.linear_velocity.rotated(deg2rad(90))
        $GolfBall.apply_impulse(Vector2(), $GolfBall.linear_velocity.normalized()*25)

func _on_ChargeTimer_timeout():
    # restart the timer if we're not maxed out yet
    if charges < max_charges:
        charge_nodes[charges].value = 100
        charges += 1
        charge_timer.start()

func _on_pickup_entered(area):
    _consume_pickup(area)
    
