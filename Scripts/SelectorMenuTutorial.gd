extends Area2D

var active


func _ready():
	connect("mouse_entered", Callable(self, "_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	active = false


func _mouse_entered():
	active = true
	var text = get_parent().get_node("MenuText")
	text.text = "START GAME\n> PLAY TUTORIAL\nEXIT"

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and active:
		# always use 1000 for the tutorial seed
		GameManager.health = 3
		GameManager.level = 0
		GameManager.score = 0
		GameManager.field_width = 5
		GameManager.crop_probability = 20
		GameManager.bird_level = 1
		GameManager.forbidden_crop_indices = [2]
		GameManager.rng_seed = 1000
		get_tree().change_scene_to_file("res://Scenes/SceneTutorial.tscn")

func _on_mouse_exited():
	active = false
	var text = get_parent().get_node("MenuText")
	text.text = "START GAME\nPLAY TUTORIAL \nEXIT"
