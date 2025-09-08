extends Button

func clicked():
	if $LineEdit.visible:
		$LineEdit.hide()
		$accept_level.hide()
	else:
		var curlevel = get_parent().get_parent().cur_level
		if curlevel and curlevel[0] == 'u':
			$LineEdit.text = curlevel.substr(7, len(curlevel) - 11)
			$accept_level.text = 'Enter level name, then click here to save level.\nLeave level name as default to modify loaded level instead of creating a new level'
		else:
			$accept_level.text = 'Enter level name, then click here to save level.'
		$LineEdit.show()
		$accept_level.show()
	
func accept_pressed():
	if ($LineEdit.text + '.txt').is_valid_filename():
		get_parent().get_parent().save_objects('user://' + $LineEdit.text + '.txt')
	else:
		get_parent().get_parent().save_objects('user://easteregg' + str(int(randf()*1000)) + '.txt')
	$LineEdit.hide()
	$accept_level.hide()
