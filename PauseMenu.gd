extends Control

export(NodePath) var music_slider_path
export(NodePath) var sfx_slider_path

var paused = false
var music_offset = -10.314
var sfx_offset = 0
var music_slider
var sfx_slider


# Called when the node enters the scene tree for the first time.
func _ready():
	music_slider = get_node(music_slider_path)
	sfx_slider = get_node(sfx_slider_path)


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


func _on_MainMenu_pressed():
	get_tree().paused = false
	paused = false
	visible = false
	get_tree().change_scene("res://World.tscn")


func _on_MusicVolumeSlider_value_changed(value):
	if music_slider.value == music_slider.min_value:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_slider.value)


func _on_SFXVolumeSlider_value_changed(value):
	if sfx_slider.value == sfx_slider.min_value:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_slider.value)
