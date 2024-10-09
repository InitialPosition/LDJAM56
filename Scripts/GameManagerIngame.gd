extends Node2D

var scene_parent
var audio_death
var audio_night
var audio_food


func _ready():
    scene_parent = get_parent()
    var noise = scene_parent.get_node("Noise")
    noise.play("noise")

    # load audio streamers
    audio_death = get_parent().get_node("AudioDeath")
    audio_night = get_parent().get_node("AudioNight")
    audio_food = get_parent().get_node("AudioFood")



func _process(delta):
    # set UI strings
    var ui = scene_parent.get_node("GUI")
    var ui_score_text = ui.get_node("ScoreCounter")

    ui_score_text.text = "SCORE " + str(GameManager.score)
