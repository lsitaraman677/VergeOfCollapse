extends Node2D

var editor
var game
var mode = 'main'

func _ready():
	editor = preload("res://editor/editor.tscn").instantiate()
	game = preload("res://background/game.tscn").instantiate()
	add_child(editor)
	add_child(game)
	$levelSelect.hide()
	main_screen()
	mode = 'main'
	
func _process(dt):
	if mode == 'level select':
		if $levelSelect.clicked_file:
			if editor.visible:
				if $levelSelect.clicked_file != '__exit__':
					editor.load_level($levelSelect.clicked_file)
				$levelSelect.hide()
				open_editor()
			else:
				if $levelSelect.clicked_file == '__exit__':
					main_screen()
				else:
					play_level($levelSelect.clicked_file)
			$levelSelect.hide()
	elif mode == 'game':
		if game.success_state == 'level select':
			game.hide()
			level_select()
	elif mode == 'editor':
		if editor.action == 'quit':
			main_screen()
		elif editor.action == 'load level':
			level_select()
			editor.action = ''
		elif editor.action == 'level saved':
			$leveLSelect.update_children()
			editor.action = ''
	queue_redraw()
	
func _draw():
	pass
	
func play_level(path):
	game.cur_level = path
	game.hide()
	game.show()
	game.get_node("Area2D/Camera2D").make_current()
	game.reset_level()
	mode = 'game'
	
func open_editor():
	editor.hide()
	editor.show()
	editor.get_node("Camera2D").make_current()
	mode = 'editor'
	
func main_screen():
	editor.hide()
	game.hide()
	$levelSelect.hide()
	$Camera2D.make_current()
	mode = 'main'
	
func level_select():
	$levelSelect.hide()
	$levelSelect.show()
	$Camera2D.make_current()
	mode = 'level select'
	
func play_pressed():
	if $levelSelect.visible or game.visible or editor.visible:
		return
	level_select()

func editor_pressed():
	if $levelSelect.visible or game.visible or editor.visible:
		return
	open_editor()
	
func raw_pressed():
	pass

func delete_user_files():
	var dir = DirAccess.open("user://")
	if dir == null:
		push_error("Could not open user://")
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != "..":
			if not dir.current_is_dir():
				var abs_path = ProjectSettings.globalize_path("user://" + file_name)
				var err = DirAccess.remove_absolute(abs_path)
				if err != OK:
					push_error("Failed to remove: %s (err %d)" % [abs_path, err])
				else:
					print("Deleted:", abs_path)
		file_name = dir.get_next()
	dir.list_dir_end()

	
