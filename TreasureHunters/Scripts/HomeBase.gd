extends Control

var curr_scene = 0

func _ready():
	play_scene()

func _process(delta):
	
	self._set_state()
	
	if Input.is_action_just_pressed("menu_select") and Global.STATE_GLOBAL == "HomeBase" and $Speech/Selector.visible == true and $Character_Select.visible == false:
		if curr_scene == 8:
			Global.STATE_GLOBAL = "Change_CharacterSelect"
			$Character_Select.visible = true
		elif curr_scene == 10:
#			Global.Player["Scene_Seen"]["New_Game"] = true
			Global.Player["Scenes"]["Homebase"]["New_Game"]["Seen"] = true
			GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])] = Global.Player
			Global.save_game()
			Global.load_level()
		else:
			curr_scene += 1
			play_scene()

	elif Input.is_action_just_pressed("menu_select") and $Character_Select.visible == true:
		$Character_Select.visible = false
		curr_scene += 1
		Global.STATE_GLOBAL = "HomeBase"
		play_scene()

func _set_state():
	if Global.STATE_GLOBAL == "Change_CharacterSelect":
		Global.STATE_GLOBAL = "CharacterSelect"

func play_scene():
	$AnimationPlayer.play("NewGame_" + str(curr_scene))
