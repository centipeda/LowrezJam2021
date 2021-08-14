extends Control


var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if !paused:
			get_tree().paused = true
			paused = true
			visible = true
		else:
			get_tree().paused = false
			paused = false
			visible = false


func _on_QuitButton_pressed():
	get_tree().quit()
