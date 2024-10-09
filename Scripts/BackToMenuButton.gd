extends Area2D

var active
var text_field
var stat_field
var new_hs


func _ready():
	connect("mouse_entered", Callable(self, "_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	text_field = get_parent()

	stat_field = get_parent().get_parent().get_node("Stats")
	stat_field.text = "FINAL LEVEL: " + str(GameManager.level) + "\nSCORE: " + str(GameManager.score)

	new_hs = get_parent().get_parent().get_node("NewHighScore")
	if GameManager.score > GameManager.high_score:
			GameManager.high_score = GameManager.score
			GameManager.save_score()

			new_hs.visible = true

	active = false

func _mouse_entered():
	active = true
	text_field.text = "> BACK TO MAIN MENU <"

func _on_mouse_exited():
	active = false
	text_field.text = "BACK TO MAIN MENU"

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and active:
		get_tree().change_scene_to_file("res://Scenes/MenuScreen.tscn")
