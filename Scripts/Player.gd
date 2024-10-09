extends Node2D


var row_length = GameManager.field_width
var diagonal_enabled = true
var target_pos
var collider
var collider_enabled = true
var mobs_moved_this_turn = false
var plants_eaten_this_turn = false
var dead_plant_tex = preload("res://ASSETS/Sprites/crop_dead.png") as Texture2D
var audio_food
var audio_complete
var lvl_complete_scene = preload("res://Scenes/LvlComplete.tscn")

const COLLIDER_THRESHOLD = 20
const LERP_STRENGTH = 0.08

func _ready():
	collider = self.get_node("Area2D")
	collider.connect("area_entered", Callable(self, "_on_area_entered"))

	audio_food = get_parent().get_parent().get_node("AudioFood")
	audio_complete = get_parent().get_parent().get_node("AudioLvlComplete")

func _process(delta):
	self.global_position = lerp(self.global_position, target_pos, LERP_STRENGTH)

	if self.global_position.distance_to(target_pos) > COLLIDER_THRESHOLD:
		collider.monitoring = false
		mobs_moved_this_turn = false
		plants_eaten_this_turn = false
	
	if !collider.monitoring:
		if self.global_position.distance_to(target_pos) < COLLIDER_THRESHOLD:
			collider.monitoring = true

			if !mobs_moved_this_turn:
				# do mob movement
				for current_mob in get_tree().get_nodes_in_group("mobs"):
					current_mob.do_move()

				mobs_moved_this_turn = true
			
			if !plants_eaten_this_turn:
				# get id from nearest tile
				var shortest_distance = INF
				var nearest_tile = null

				for current_node in get_tree().get_nodes_in_group("tiles"):
					if self.global_position.distance_to(current_node.global_position) < shortest_distance:
						shortest_distance = self.global_position.distance_to(current_node.global_position)
						nearest_tile = current_node
				
				var tile_plant = nearest_tile.get_parent().get_node("Sprite2D_Crop")
				if tile_plant.visible and tile_plant.texture != dead_plant_tex:
					tile_plant.texture = dead_plant_tex

					audio_food.pitch_scale = randf_range(0.8, 1.2)
					audio_food.play()

					GameManager.score += GameManager.crop_score

					# win detection
					GameManager.crop_count -= 1
					if GameManager.crop_count == 0:
						# if we play the tutorial, go back to main menu here
						if get_tree().current_scene.name == "TutorialScene":
							get_tree().change_scene_to_file("res://Scenes/MenuScreen.tscn")
							return
						
						audio_complete.play()

						var win_screen = lvl_complete_scene.instantiate()
						get_parent().get_parent().add_child(win_screen)
						win_screen.global_position = Vector2(0, 0)

						# let the sound play
						await get_tree().create_timer(1.5).timeout

						GameManager.rng_seed += 1
						GameManager.level += 1

						if GameManager.level == 4:
							GameManager.crop_probability = 25
							GameManager.bird_level = 2
							GameManager.field_width = 7
							GameManager.forbidden_crop_indices = [1, 5]
						elif GameManager.level == 8:
							GameManager.crop_probability = 35
							GameManager.bird_level = 3
							GameManager.forbidden_crop_indices = [1, 3, 5]
						elif GameManager.level == 15:
							GameManager.crop_probability = 40
							GameManager.bird_level = 4
							GameManager.field_width = 9
							GameManager.forbidden_crop_indices = [1, 3, 5]

						get_tree().reload_current_scene()

					plants_eaten_this_turn = true

func _on_area_entered(area):
	activate_tiles()

func activate_tiles():
	# get id from nearest tile
	var shortest_distance = INF
	var nearest_tile = null

	for current_node in get_tree().get_nodes_in_group("tiles"):
		if self.global_position.distance_to(current_node.global_position) < shortest_distance:
			shortest_distance = self.global_position.distance_to(current_node.global_position)
			nearest_tile = current_node

	for current_node in get_tree().get_nodes_in_group("tiles"):
		current_node.line.visible = false

		var test_id = current_node.id_number
		if test_id == nearest_tile.id_number - row_length or (test_id == nearest_tile.id_number - 1 and nearest_tile.id_number % row_length != 0) or (test_id == nearest_tile.id_number + 1 and nearest_tile.id_number % row_length != row_length - 1) or test_id == nearest_tile.id_number + row_length:
			current_node.line.visible = true
		
		# if we have the diagonal movement upgrade, enable diagonal tiles
		if diagonal_enabled:
			if (test_id == (nearest_tile.id_number - row_length) - 1 and (nearest_tile.id_number - row_length) % row_length != 0) or (test_id == (nearest_tile.id_number - row_length) + 1 and ((nearest_tile.id_number - row_length) + 1) % row_length != 0) or (test_id == (nearest_tile.id_number + row_length) - 1 and (nearest_tile.id_number + row_length) % row_length != 0) or (test_id == (nearest_tile.id_number + row_length) + 1 and ((nearest_tile.id_number + row_length) + 1) % row_length != 0):
				current_node.line.visible = true
