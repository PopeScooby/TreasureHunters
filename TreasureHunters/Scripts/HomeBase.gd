extends Control

var curr_scene = 0

func _ready():
	Global.Player["Scenes"]["Scene_Curr"]["SceneName"] = "Homebase_Intro_01"
	Global.STATE_GLOBAL = "Play_Scene"


func _process(delta):
	if Global.STATE_GLOBAL == "Play_Scene":
		
		exec_state_start_scene()
		Global.STATE_GLOBAL = "Playing_Scene"
	
	elif Input.is_action_just_pressed("menu_select") and Global.STATE_GLOBAL == "Scene_Waiting" and $Speech/Selector.visible == true and $Character_Select.visible == false:
	
		var this_scene = Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
		var next_scene = Global.Player["Scenes"][this_scene]["Next"]
		
		Global.Player["Scenes"][this_scene]["Seen"] = true
		
		if next_scene != "":
			Global.Player["Scenes"]["Scene_Curr"]["SceneName"] = next_scene
			exec_state_start_scene()
		else:
			if Global.Player["Name_Explorer"] == "":
				$Character_Select.visible = true
				Global.STATE_GLOBAL = "To_CharacterSelect"
			else:
				Global.STATE_PLAYER = ""
				Global.save_game()
				Global.load_level()
	
#	elif Input.is_action_just_pressed("menu_select") and $Character_Select.visible == true:
#		$Character_Select.visible = false
#		Global.Player["Scenes"]["Scene_Curr"]["SceneName"] = "Homebase_Intro_09"
#		Global.STATE_GLOBAL = "Play_Scene"

func exec_state_start_scene():
	var anim_name = Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
	$AnimationPlayer.play(anim_name)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.find("Homebase_Intro") != -1:
		Global.STATE_GLOBAL = "Scene_Waiting"



#
#func _ready():
#	play_scene()

#
#func _process(delta):
#
#	self._set_state()
#
#	if Input.is_action_just_pressed("menu_select") and Global.STATE_GLOBAL == "HomeBase" and $Speech/Selector.visible == true and $Character_Select.visible == false:
#		if curr_scene == 8:
#			Global.STATE_GLOBAL = "Change_CharacterSelect"
#			$Character_Select.visible = true
#		elif curr_scene == 10:
#			Global.Player["Scenes"]["New_Game"]["Seen"] = true
#			GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])] = Global.Player
#			Global.save_game()
#			Global.load_level()
#		else:
#			curr_scene += 1
#			play_scene()
#
#	elif Input.is_action_just_pressed("menu_select") and $Character_Select.visible == true:
#		$Character_Select.visible = false
#		curr_scene += 1
#		Global.STATE_GLOBAL = "HomeBase"
#		play_scene()
#
#func _set_state():
#	if Global.STATE_GLOBAL == "Change_CharacterSelect":
#		Global.STATE_GLOBAL = "CharacterSelect"
#
#func play_scene():
#	$AnimationPlayer.play("NewGame_" + str(curr_scene))

