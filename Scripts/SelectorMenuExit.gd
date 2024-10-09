extends Area2D

var active


func _ready():
	connect("mouse_entered", Callable(self, "_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	active = false

	# the menu button will now set the high score text. it is late. im sorry
	if GameManager.high_score != 0:
		var highscore_text = get_parent().get_node("HighScore")
		highscore_text.visible = true
		highscore_text.text = "HIGHSCORE " + str(GameManager.high_score)


func _mouse_entered():
	active = true
	var text = get_parent().get_node("MenuText")
	text.text = "START GAME\nPLAY TUTORIAL\n> EXIT"

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and active:
		get_tree().quit()

func _on_mouse_exited():
	active = false
	var text = get_parent().get_node("MenuText")
	text.text = "START GAME\nPLAY TUTORIAL \nEXIT"
