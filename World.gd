extends Node2D

export(PackedScene) var menu_scene
export(PackedScene) var game_scene


# Called when the node enters the scene tree for the first time.
func _ready():
    add_child(menu_scene.instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_load_level(level):
    get_child(0).queue_free()
    var game = game_scene.instance()
    game.load_level(level)
    add_child(game)
