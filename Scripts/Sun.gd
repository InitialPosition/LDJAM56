extends Node2D


var is_daytime
var light_day
var light_night
var target_light
var current_light
var current_light_bg
var target_light_bg
var bg_day
var bg_night
var fading_speed
var is_fading = false
var fade = 0
var gui_day_indicator
var gui_day_indicator_text
var background
var bg_particles
var day_turns = 5
var night_turns = 3
var turn_counter = 0
var audio_night


# Called when the node enters the scene tree for the first time.
func _ready():
	light_day = Color.from_hsv(0.15, 0.9, 1, 1)
	light_night = Color.from_hsv(0.66, 0.6, 0.6, 1)

	background = get_parent().get_node("BGColor")

	bg_day = Color.from_hsv(0, 0.1, 0.1, 0.2)
	bg_night = Color.from_hsv(0.66, 0.1, 0.1, 0.2)
	
	self.color = light_day
	background.color = bg_day

	fading_speed = 0.02

	is_daytime = true
	gui_day_indicator = get_parent().get_node("GUI").get_node("DaytimeIndicator")
	gui_day_indicator_text = get_parent().get_node("GUI").get_node("MoveCounter")

	gui_day_indicator_text.text = str(day_turns - turn_counter) + " MOVES UNTIL"

	audio_night = get_parent().get_node("AudioNight")

func advance_time():
	turn_counter += 1

	# update the UI
	if is_daytime:
		gui_day_indicator_text.text = str(day_turns - turn_counter) + " MOVES UNTIL"

		if turn_counter >= day_turns:
			turn_counter = 0
			is_daytime = false
			set_sun(is_daytime)

			gui_day_indicator_text.text = str(night_turns - turn_counter) + " MOVES UNTIL"
	else:
		gui_day_indicator_text.text = str(night_turns - turn_counter) + " MOVES UNTIL"

		if turn_counter >= night_turns:
			turn_counter = 0
			is_daytime = true
			set_sun(is_daytime)

			gui_day_indicator_text.text = str(day_turns - turn_counter) + " MOVES UNTIL"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_fading:
		if fade >= 1:
			is_fading = false
			self.color = target_light
		
		self.color = lerp(current_light, target_light, fade)
		background.color = lerp(current_light_bg, target_light_bg, fade)
		fade += fading_speed


func set_sun(is_daytime):
	if is_daytime:
		target_light = light_day
		current_light = light_night

		current_light_bg = bg_night
		target_light_bg = bg_day
		
		gui_day_indicator.get_node("AnimatedSprite2D").frame = 0
	else:
		target_light = light_night
		current_light = light_day

		current_light_bg = bg_day
		target_light_bg = bg_night

		gui_day_indicator.get_node("AnimatedSprite2D").frame = 1
		audio_night.play()
	
	fade = 0
	is_fading = true
