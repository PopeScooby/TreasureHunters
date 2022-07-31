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
		elif selector_curr == 0 and $Menu_NewGame/NewNameTxt.text != "":
			_new_player()
	
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
	$Menu_NewGame/NewNameTxt.grab_focus()

func _new_player():
#
#	var NewPlayerKey
#	if Global.players.has("1"):
#		NewPlayerKey = Global.players.size() + 1
#	else:
#		NewPlayerKey = 1
#
#	var NewPlayer = {"Name": "", 
#					 "Hearts": 3, 
#					 "Hearts_Total": 3,
#					 "Coins": 0, 
#					 "Coins_Collected": 0,
#					 "Treasure": [],
#					 "Level_Current": 1,
#					 "Level_Max": 1,
#					 "Animation": "",
#					 "Levels": {"1" : {"Coins_Collected": 0,
#									   "Coins": [true, true, true, true],
#									   "Treasure": true,
#									   "Complete": false
#									},
#								"2" : {"Coins_Collected": 0,
#									   "Coins": [true, true, true, true, true, true],
#									   "Treasure": true,
#									   "Complete": false
#									},
#								"3" : {"Coins_Collected": 0,
#									   "Coins": [true, true, true, true, true, true, true, true, true, true],
#									   "Treasure": true,
#									   "Complete": false
#									},
#								"4" : {"Coins_Collected": 0,
#									   "Coins": [true, true, true, true, true, true, true, true, true, true, true, true, true, true],
#									   "Treasure": true,
#									   "Complete": false
#									},
#								"5" : {"Coins_Collected": 0,
#									   "Coins": [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
#									   "Treasure": true,
#									   "Complete": false
#									},
#								"6" : {"Coins_Collected": 0,
#									   "Coins": [true],
#									   "Treasure": true,
#									   "Complete": false
#									}
#								},
#					 "Player_Info" : {"Friction": false,
#									  "Gravity": 45,
#									  "Acceleration": 200,
#									  "SpeedMax": 800,
#									  "JumpHeight": -1800,
#									  "Dir_Curr": 1,
#									  "Dir_Prev": 1},
#					 "Player_Flags" : {"Can_Exit": false,
#									   "Can_Climb": false,
#									   "Can_Push": false,
#									   "Crate_R": false,
#									   "Can_OpenChest": false}
#					}
#
#	Global.game["PlayerKey"] = NewPlayerKey
#	Global.players[str(NewPlayerKey)] = NewPlayer
#	Global.save_game()
#	Global.new_game()
	pass

func _continue():
	get_tree().change_scene("res://Scenes/Interface/Menu_PlayerSelect.tscn")


