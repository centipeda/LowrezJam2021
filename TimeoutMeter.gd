extends Control

var combo = 0
var comboeing = false

# Called when the node enters the scene tree for the first time.
func _ready():
    $TimeoutMeter.value = 100

func _process(_delta):
    var percent
    if comboeing:
        percent = 100
    else:
        percent = $TimeoutTimer.time_left / $TimeoutTimer.wait_time * 100
        # this is to make it so the bar completely fills up at some point
        if percent > 97:
            percent = 100
    $TimeoutMeter.value = ceil(percent)


func add_combo():
    combo += 1
    $ComboIndicator/ComboLabel.text = str(combo)
    if combo > 1:
        $ComboIndicator.visible = true
        comboeing = true
        $TimeoutTimer.stop()
        $ComboTimer.start()
    else:
        $TimeoutTimer.start()

func reset_combo():
    combo = 0
    comboeing = false
    $ComboTimer.stop()
    $TimeoutTimer.start()
    $ComboIndicator.visible = false

func _on_ComboTimer_timeout():
    reset_combo()
