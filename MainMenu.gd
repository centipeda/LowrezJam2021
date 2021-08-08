extends Control

export(PackedScene) var game_scene

var level_names = [
    "fire temple",
    "desert temple",
    "grassland",
    "ice floes",
    "cpu temple",
    "window temple"
   ]

# Called when the node enters the scene tree for the first time.
func _ready():
    $LevelMenu.visible = false
    $StartMenu.visible = true

func _process(_delta):
    pass

func _on_StartButton_pressed():
    $StartMenu.visible = false
    $LevelMenu.visible = true

func _on_QuitButton_pressed():
    get_tree().quit()

func _level_enter():
    $LevelMenu/HiScore.visible = true
    $LevelMenu/HiScoreLabel.visible = true

func _on_Level1_mouse_entered():
    _level_enter()
    $LevelMenu/LevelName.text = level_names[0]
func _on_Level2_mouse_entered():
    _level_enter()
    $LevelMenu/LevelName.text = level_names[1]
func _on_Level3_mouse_entered():
    _level_enter()
    $LevelMenu/LevelName.text = level_names[2]
func _on_Level4_mouse_entered():
    _level_enter()
    $LevelMenu/LevelName.text = level_names[3]
func _on_Level5_mouse_entered():
    _level_enter()
    $LevelMenu/LevelName.text = level_names[4]
func _on_Level6_mouse_entered():
    _level_enter()
    $LevelMenu/LevelName.text = level_names[5]

func _on_Level_mouse_exited():
    $LevelMenu/LevelName.text = "level select"
    $LevelMenu/HiScore.visible = false
    $LevelMenu/HiScoreLabel.visible = false
