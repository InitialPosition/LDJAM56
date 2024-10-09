extends Area2D

var active


func _ready():
	connect("mouse_entered", Callable(self, "_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	var music = MusicPlayer.get_node("AudioStreamPlayer")
	if !music.is_playing():
		MusicPlayer.get_node("AudioStreamPlayer").play()

	active = false


func _mouse_entered():
	active = true
	var text = get_parent().get_node("MenuText")
	text.text = "> START GAME\nPLAY TUTORIAL\nEXIT"

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and active:
		GameManager.health = 3
		GameManager.level = 1
		GameManager.score = 0
		GameManager.field_width = 5
		GameManager.crop_probability = 20
		GameManager.bird_level = 1
		GameManager.forbidden_crop_indices = [2]
		GameManager.rng_seed = randi()
		get_tree().change_scene_to_file("res://Scenes/SceneGame.tscn")

func _on_mouse_exited():
	active = false
	var text = get_parent().get_node("MenuText")
	text.text = "START GAME\nPLAY TUTORIAL\nEXIT"
