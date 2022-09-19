extends Control

var selector_curr = 1
var selector_locations = {1:532, 2:592, 3:652}

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("menu_down") and selector_curr != 0:
		if selector_curr != 3:
			selector_curr += 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_up") and selector_curr != 0:
		if selector_curr != 1:
			selector_curr -= 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_select"):
		if selector_curr == 1:
			_new_game()
		elif selector_curr == 2:
			_continue()
		elif selector_curr == 3:
			get_tree().quit()
#		elif selector_curr == 0 and $Menu_NewGame/NewNameTxt.text != "":
#			_new_player()
	
	elif Input.is_action_just_pressed("menu_back"):
		if selector_curr == 0:
			selector_curr = 1
			get_node("Selector").visible = true
			get_node("Menu_NewGame").visible = false

func _move_selector():
	get_node("Selector").rect_position.y = selector_locations[selector_curr]

func _new_game():
	selector_curr = 0
	get_node("Selector").visible = false
	get_node("Menu_NewGame").visible = true
#	$Menu_NewGame/NewNameTxt.grab_focus()
#
#func _new_player():
#
#	Global.new_game($Menu_NewGame/NewNameTxt.text)
#	Global.STATE_GLOBAL = "HomeBase"


func _continue():
	get_tree().change_scene("res://Scenes/Interface/Menu_PlayerSelect.tscn")
	pass


