extends Area2D

var line
var id_number
var row_length
var cancelled
var diagonal_enabled = false
var col_normal = Color(0.2, 0.2, 0.2)
var col_select = Color(1, 1, 1)
var daytime

func _ready():
	row_length = GameManager.field_width
	cancelled = false

	add_to_group("tiles")

	line = get_parent().get_node("Line2D")
	line.default_color = col_normal

	daytime = get_parent().get_parent().get_parent().get_node("Sun")

	id_number = len(get_tree().get_nodes_in_group("tiles")) - 1

	connect("mouse_entered", Callable(self, "_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("input_event", Callable(self, "_on_input_event"))

func highlight_movable_tiles():
	for current_node in get_tree().get_nodes_in_group("tiles"):
		current_node.line.visible = false

		var test_id = current_node.id_number
		if test_id == self.id_number - row_length or (test_id == self.id_number - 1 and self.id_number % row_length != 0) or (test_id == self.id_number + 1 and self.id_number % row_length != row_length - 1) or test_id == self.id_number + row_length:
			current_node.line.visible = true
		
		# if we have the diagonal movement upgrade, enable diagonal tiles
		if diagonal_enabled:
			if (test_id == (self.id_number - row_length) - 1 and (self.id_number - row_length) % row_length != 0) or (test_id == (self.id_number - row_length) + 1 and ((self.id_number - row_length) + 1) % row_length != 0) or (test_id == (self.id_number + row_length) - 1 and (self.id_number + row_length) % row_length != 0) or (test_id == (self.id_number + row_length) + 1 and ((self.id_number + row_length) + 1) % row_length != 0):
				current_node.line.visible = true

func _mouse_entered():
	line.default_color = col_select

func _on_mouse_exited():
	line.default_color = col_normal

func _on_input_event(viewport, event, shape_idx):
	var player = get_parent().get_parent().get_node("Player")

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if line.visible:
				for current_node in get_tree().get_nodes_in_group("tiles"):
					current_node.line.visible = false

				
				if player.collider.monitoring:
					player.target_pos = self.global_position
					daytime.advance_time()
