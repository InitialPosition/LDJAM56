extends Node2D

var texts = [
	"Your goal is to consume all wheat patches in the stage.",
	"Watch out for birds! If they catch you, it's game over!",
	"During nighttime, birds won't move or hurt you.",
	"Consume all wheat patches to finish the tutorial!"
]
var current_text = -1
var text_box
var rect
var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	text_box = get_parent().get_node("TutorialText")
	rect = get_parent().get_node("TutorialRect")
	
	GameManager.health = 3

func _input(event):
	if Input.is_action_just_pressed("mouse_click") and active:
		current_text += 1

		if current_text >= len(texts):
			active = false
			text_box.queue_free()
			rect.queue_free()
			return
		
		text_box.text = texts[current_text]
