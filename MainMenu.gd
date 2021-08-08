extends Control

export(PackedScene) var game_scene

signal load_level (level)

var level_names = [
    "fire temple",
    "desert temple",
    "grassland",
    "ice floes",
    "cpu temple",
    "window temple"
   ]
var active_level = 0
var level_select = false

# Called when the node enters the scene tree for the first time.
func _ready():
    $LevelMenu.visible = false
    $StartMenu.visible = true
    connect("load_level", get_parent(), "_on_load_level")

func _process(_delta):
    pass

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            if level_select:
                print("clicked", active_level)
                emit_signal("load_level", active_level)

func _on_StartButton_pressed():
    $StartMenu.visible = false
    $LevelMenu.visible = true
    level_select = true

func _on_QuitButton_pressed():
    get_tree().quit()

func _level_enter(level):
    $LevelMenu/HiScore.visible = true
    $LevelMenu/HiScoreLabel.visible = true
    $LevelMenu/LevelName.text = level_names[level]
    $LevelMenu/HiScore.text = str($SaveData.data["high_scores"][level])
    active_level = level

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
