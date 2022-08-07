extends Control

var selector_curr = 1
var selector_locations = {1:170, 2:705}


func _ready():
	
	_move_selector()

func _process(delta):
	
	if Global.STATE_GLOBAL == "CharacterSelect":
		if Input.is_action_just_pressed("menu_left") and self.visible == true:
			if selector_curr != 1:
				selector_curr -= 1
				_move_selector()
		elif Input.is_action_just_pressed("menu_right") and self.visible == true:
			if selector_curr != 2:
				selector_curr += 1
				_move_selector()
		elif Input.is_action_just_pressed("menu_select") and self.visible == true:
			if selector_curr == 1:
				Global.player["Name_Explorer"] = "Inda"
			else:
				Global.player["Name_Explorer"] = "Lary"
			Global.STATE_GLOBAL = "HomeBase"

func _move_selector():
	get_node("Selector").rect_position.x = selector_locations[selector_curr]
