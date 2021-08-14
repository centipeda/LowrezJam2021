extends Control

export(PackedScene) var game_scene

signal load_level (level)

var level_nodes
var level_names = [
	"fire temple",
	"desert temple",
	"grassland",
	"ice floes",
	"cpu temple",
	"window"
   ]
var active_level = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelMenu.visible = false
	$StartMenu.visible = true
	connect("load_level", get_parent(), "_on_load_level")
	level_nodes = [
		$LevelMenu/Level1,
		$LevelMenu/Level2,
		$LevelMenu/Level3,
		$LevelMenu/Level4,
		$LevelMenu/Level5,
		$LevelMenu/Level6,
	   ]
	for level_idx in range(level_nodes.size()):
		if $SaveData.data["unlocked"][level_idx]:
			level_nodes[level_idx].get_node("Locked").visible = false
		else:
			level_nodes[level_idx].get_node("Locked").visible = true

func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			# only load into the game if we're at the level select screen
			if active_level >= 0 and $LevelMenu.visible:
				print("clicked", active_level)
				emit_signal("load_level", active_level)

func _on_StartButton_pressed():
	$SFX/Start.play()
	$StartMenu.visible = false
	$LevelMenu.visible = true
	$StartMenu/BallLayer/Ball/CollisionShape2D.disabled = true
	$StartTimer.start()

func _on_QuitButton_pressed():
	$SFX/DeathNoise.play()
	get_tree().quit()

func _level_enter(level_idx):
	# if the locked node is visible then the level isn't unlocked yet
	if level_nodes[level_idx].get_node("Locked").visible:
		active_level = -1
		$LevelMenu/HiScore.visible = false
		$LevelMenu/HiScoreLabel.visible = false
		$LevelMenu/LevelLocked.visible = true
	else:
		if $StartTimer.time_left == 0:
			$SFX/Select1.play()
		active_level = level_idx
		$LevelMenu/HiScore.visible = true
		$LevelMenu/HiScoreLabel.visible = true
		$LevelMenu/LevelLocked.visible = false
	$LevelMenu/HiScore.text = str($SaveData.data["high_scores"][level_idx])
	$LevelMenu/LevelName.text = level_names[level_idx]

func _on_Level1_mouse_entered():
	_level_enter(0)
func _on_Level2_mouse_entered():
	_level_enter(1)
func _on_Level3_mouse_entered():
	_level_enter(2)
func _on_Level4_mouse_entered():
	_level_enter(3)
func _on_Level5_mouse_entered():
	_level_enter(4)
func _on_Level6_mouse_entered():
	_level_enter(5)

func _on_Level_mouse_exited():
	$LevelMenu/LevelName.text = "level select"
	$LevelMenu/HiScore.visible = false
	$LevelMenu/HiScoreLabel.visible = false
	active_level = -1


func _on_Ball_body_entered(body):
	$SFX/TakeHit.play()
