extends Area2D

var active


func _ready():
	connect("mouse_entered", Callable(self, "_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	var music = MusicPlayer.get_node("AudioStreamPlayer")
	if !music.is_playing():
		MusicPlayer.get_node("AudioStreamPlayer").play()

	get_parent().get_parent().get_node("VersionString").text = "v. " + str(ProjectSettings.get_setting("application/config/version"))

	active = false


func _mouse_entered():
	active = true
	var text = get_parent().get_node("MenuText")
	text.text = "> START GAME\nPLAY TUTORIAL\nEXIT"

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and active:
		GameManager.reset_stats()
		get_tree().change_scene_to_file("res://Scenes/SceneGame.tscn")

func _on_mouse_exited():
	active = false
	var text = get_parent().get_node("MenuText")
	text.text = "START GAME\nPLAY TUTORIAL\nEXIT"
