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
    if get_child_count() > 0:
        get_child(0).queue_free()
    var game = game_scene.instance()
    game.load_level(level)
    add_child(game)

func _on_load_menu():
    if get_child_count() > 0:
        get_child(0).queue_free()
    var menu = menu_scene.instance()
    add_child(menu)
