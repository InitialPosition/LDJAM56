extends Node2D

var score = 0
var high_score = 0
var level = 1
var field_width = 5
var health = 3
var rng_seed = 2000
var crop_count = 0
var crop_probability = 20
var bird_level = 1

var forbidden_crop_indices = [2]

var crop_score = 500


func _ready():
	load_score()

func save_score():
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)

	if file != null:
		file.store_var(self.high_score)
		file.close()

func load_score():
	var file = FileAccess.open("user://savegame.save", FileAccess.READ)

	if file != null:
		self.high_score = file.get_var()
		file.close()

func reset_stats():
	health = 3
	level = 1
	score = 0
	field_width = 5
	crop_probability = 20
	bird_level = 1
	forbidden_crop_indices = [2]
	rng_seed = randi()
