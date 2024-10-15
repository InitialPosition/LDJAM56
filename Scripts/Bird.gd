extends "res://Scripts/Mob.gd"

var target_pos
var is_sleeping = false
var collider
var player
var sun
var audio_death
var death_scene = preload("res://Scenes/Death.tscn")

const LERP_STRENGTH = 0.08
const FLAPPING_THRESHOLD = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	$AnimatedSprite2D.play("idle")

	target_pos = self.global_position

	collider = self.get_node("Area2D")
	collider.connect("area_entered", Callable(self, "_on_area_entered"))

	sun = get_parent().get_parent().get_node("Sun")

	audio_death = get_parent().get_parent().get_node("AudioDeath")

func do_move():
	# do not move if bird is sleeping
	is_sleeping = !sun.is_daytime
	if is_sleeping:
		return

	# find the closest way to the player
	self.global_position = round(self.global_position)
	var current_position = self.target_pos

	var player_object = get_parent().get_node("Player")
	var player_position = player_object.global_position
	
	var smallest_distance = INF
	var best_movement_vector = null
	for movement_vector in [Vector2(0, 128), Vector2(0, -128), Vector2(128, 0), Vector2(-128, 0)]:# , Vector2(128, 128), Vector2(128, -128), Vector2(-128, 128), Vector2(-128, -128)]:
		var new_pos = round(current_position + movement_vector)
		# if position is out of bounds, block immediately
		if new_pos.x < 150 or new_pos.x > 1150 or new_pos.y < 100 or new_pos.y > 700:
			continue

		# check no other mob is here
		var place_taken = false
		for current_mob in get_tree().get_nodes_in_group("mobs"):
			if current_mob == self:
				continue

			if round(current_mob.target_pos) == new_pos:
				place_taken = true
				break
		
		if place_taken:
			continue

		if new_pos.distance_to(player_position) < smallest_distance:
			smallest_distance = new_pos.distance_to(player_position)
			best_movement_vector = movement_vector
	
	if best_movement_vector != null:
		target_pos += best_movement_vector


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = lerp(self.global_position, target_pos, LERP_STRENGTH)

	if !is_sleeping:
		$AnimatedSprite2D.flip_h = self.global_position.x < target_pos.x
		if self.global_position.distance_to(target_pos) > FLAPPING_THRESHOLD:
			$AnimatedSprite2D.play("flapping")
		else:
			$AnimatedSprite2D.play("idle")

	else:
		$AnimatedSprite2D.play("sleeping")

func _on_area_entered(other):
	player = get_parent().get_node("Player")

	if other == player.get_node("Area2D"):
		if !is_sleeping and other.monitoring:
			audio_death.pitch_scale = randf_range(0.9, 1.1)
			audio_death.play()

			var lose_screen = death_scene.instantiate()
			get_parent().get_parent().add_child(lose_screen)
			lose_screen.global_position = Vector2(0, 0)

			await get_tree().create_timer(1.5).timeout

			GameManager.health -= 1
			if GameManager.health == 0:
				get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
				return

			get_tree().reload_current_scene()
