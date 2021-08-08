extends Node

export(String) var default_save_file

var save_filename
var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
    save_filename = "user://" + default_save_file
    load_data()
    
func _load_default_data():
    return {
        "high_scores": [
            0, 0, 0, 0, 0, 0
        ],
        "unlocked": [
            true, false, false, false, false, false
        ]
    }

func save_data():
    var save_game = File.new()
    save_game.open(save_filename, File.WRITE)
    save_game.store_line(to_json(data))
    save_game.close()

# load the save data, loading default data if a save file doesn't exist
func load_data():
    var save_game = File.new()
    if not save_game.file_exists(save_filename):
        data = _load_default_data()
        return
    save_game.open(filename)
    data = parse_json(save_game.get_line())
    save_game.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
