extends Node2D

# variable to hold the current field
var Tile = preload("res://Scenes/Objects/Tile.tscn")
var Bird = preload("res://Scenes/Objects/Hazards/Bird.tscn")
var Player = preload("res://Scenes/Player.tscn")
var rng = RandomNumberGenerator.new()
var sprite
var sprite_width
var sprite_height
const TILE_SIZE = 128
var game_manager


func _ready():
	rng.seed = hash(GameManager.rng_seed)

	game_manager = get_parent().get_node("GameManager")

	var field_width = GameManager.field_width
	var field_height = 5

	# move to center of game screen
	var screen_width = get_viewport().size.x
	var total_field_width = (field_width - 1) * TILE_SIZE
	var centered_x = (screen_width - total_field_width) / 2
	self.position = Vector2(centered_x, TILE_SIZE)

	if GameManager.bird_level == 1:
		var bird = Bird.instantiate()
		add_child(bird)

		var startpos_bird = Vector2(TILE_SIZE * 5, TILE_SIZE)
		bird.global_position = startpos_bird
		bird.target_pos = startpos_bird
	elif GameManager.bird_level == 2:
		for i in [3, 7]:
			var bird = Bird.instantiate()
			add_child(bird)

			var startpos_bird = Vector2(TILE_SIZE * i, TILE_SIZE)
			bird.global_position = startpos_bird
			bird.target_pos = startpos_bird
	elif GameManager.bird_level == 3:
		for i in [3, 5, 7]:
			var bird = Bird.instantiate()
			add_child(bird)

			var startpos_bird = Vector2(TILE_SIZE * i, TILE_SIZE)
			bird.global_position = startpos_bird
			bird.target_pos = startpos_bird
	elif GameManager.bird_level == 4:
		for i in [3, 5, 7]:
			var bird = Bird.instantiate()
			add_child(bird)

			var startpos_bird = Vector2(TILE_SIZE * i, TILE_SIZE)
			bird.global_position = startpos_bird
			bird.target_pos = startpos_bird

	var player = Player.instantiate()
	player.name = "Player"
	add_child(player)
	player.global_position = Vector2(TILE_SIZE * 5, TILE_SIZE * 3)
	player.target_pos = player.global_position
	
	generate_field(field_width, field_height)

# generate a playing field.
func generate_field(field_width, field_height):
	rng.seed = hash(GameManager.rng_seed)

	GameManager.crop_count = 0

	var spawn_field = ceil((GameManager.field_width * field_height) / 2)
	var counter = 0

	for row in range(field_height):
		for col in range(field_width):
			var tile = Tile.instantiate()

			# calculate tile position
			var tile_x = get_parent().position.x + TILE_SIZE * col
			var tile_y = get_parent().position.y + TILE_SIZE * row
			tile.position = Vector2(tile_x, tile_y)
			
			# if tile is determined to be a field, change, otherwise add decor
			if rng.randi() % 100 <= GameManager.crop_probability and counter != spawn_field and counter not in GameManager.forbidden_crop_indices:
				tile.get_node("Sprite2D_Crop").visible = true
				GameManager.crop_count += 1
			
			# add the tile to the field as a child
			add_child(tile)

			# increment counter
			counter += 1
