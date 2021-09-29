extends TileMap

const TILE_SIZE = 64

export(int) var width
export(int) var height

var time_spent = 0
var time_modulator = 0.2

var playing = false

var temp_field

func clear_field():
	temp_field = []
	for x in range(width * 2):
		var temp = []
		for y in range(height * 2):
			set_cell(x, y, 0)
			temp.append(0)
		temp_field.append(temp)

func _ready():
	var width_px = width * TILE_SIZE * 2
	var height_px = height * TILE_SIZE * 2

	var cam = $Camera2D
	cam.position = Vector2(width_px, height_px)/2
	cam.zoom = Vector2(width_px, height_px) / Vector2(1920, 1080)

	clear_field()


func _input(event):
	if event.is_action_pressed("toggle_play"):
		playing = !playing

	if event.is_action_pressed("click"):
		var pos = (get_local_mouse_position()/TILE_SIZE).floor()
		set_cellv(pos, 1-get_cellv(pos))
	
	if event.is_action_pressed("faster"):
		time_modulator -= 0.05
		
	
	if event.is_action_pressed("reset_time"):
		time_modulator = 0.2
	
	if event.is_action_pressed("slower"):
		time_modulator += 0.05

	if event.is_action_pressed("clear_field"):
		clear_field()

	# get_node("./time").set_text(str(time_modulator))

func _process(delta):
	update_field(delta)


func update_field(delta):
	if !playing:
		return

	time_spent += delta
	
	if time_spent < time_modulator:
		return

	else:
		time_spent = 0

	# Le but est de modifier les états des cellules du temp_field

	for x in range(width * 2):

		for y in range(height * 2):
			var live_neighbors = 0

			for x_off in [-1, 0, 1]:
				for y_off in [-1, 0, 1]:
					if x_off != y_off or x_off != 0:
						if get_cell(x+x_off, y+y_off) == 1:
							live_neighbors += 1

			if get_cell(x, y) == 1:
				if live_neighbors in [2, 3]:
					temp_field[x][y] = 1

				else:
					temp_field[x][y] = 0

			else:
				if live_neighbors == 3:
					temp_field[x][y] = 1

				else:
					temp_field[x][y] = 0


	# Mise à jour du tableau
	for x in range(width * 2):

		for y in range(height * 2):
			set_cell(x, y, temp_field[x][y])





