extends Control

var hp_display
var level_display

func _ready():
	hp_display = self.get_node("LocustCounter")
	level_display = self.get_node("LevelName")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hp_display.text = str(GameManager.health)
	level_display.text = "LEVEL " + str(GameManager.level)
