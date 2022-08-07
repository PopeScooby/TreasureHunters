extends KinematicBody2D

const UP = Vector2(0,-1)

var STATES = ["Spawn_Player","Player_Spawning","Move_Normal"]

var motion = Vector2(0,0)

func _ready():
	self.visible = false
	set_player()

func _process(delta):
	
	check_state()
	exec_state()

func check_state():
	pass
	if Global.STATE_LEVEL == "Spawn_Player":
		Global.STATE_PLAYER = "Spawn_Player"
	elif Global.STATE_PLAYER == "OnCrate":
		Global.Player["Player_Flags"]["Can_Push"] = true
		Global.STATE_PLAYER = "Move_Normal"
	elif Global.STATE_PLAYER == "OffCrate":
		Global.Player["Player_Flags"]["Can_Push"] = false
		Global.STATE_PLAYER = "Move_Normal"
#	elif Global.STATE_PLAYER == "Play_Scene":
#		self.check_state_play_scene()

func exec_state():
	if Global.STATE_PLAYER == "Spawn_Player":
		exec_state_spawn_player()
	elif Global.STATE_PLAYER == "Move_Normal":
		exec_state_move()
#	elif Global.STATE_PLAYER.left(5) == "Scene":
#		exec_state_scene()

func exec_state_move():
	
	if GlobalDictionaries.player_info["Dir_Curr"] != 0:
		GlobalDictionaries.player_info["Dir_Prev"] = GlobalDictionaries.player_info["Dir_Curr"]

	GlobalDictionaries.player_info["Friction"] = false

	motion.y += GlobalDictionaries.player_info["Gravity"]

	if Input.is_action_just_pressed("action_interact") and Global.Player["Player_Flags"]["Can_OpenChest"] == true:
		exec_state_open_chest()
	elif Input.is_action_just_pressed("action_interact") and Global.Player["Player_Flags"]["On_Exit"] == true:
		exec_state_despawn_player()
	elif Input.is_action_pressed("move_right"):
		exec_state_move_right()
	elif Input.is_action_pressed("move_left"):
		exec_state_move_left()
	else:
		exec_state_idle()

	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			exec_state_move_jump()

		if GlobalDictionaries.player_info["Friction"] == true:
			motion.x = lerp(motion.x, 0, 0.8)
	else:
		if GlobalDictionaries.player_info["Friction"] == true:
			motion.x = lerp(motion.x, 0, 0.4)

	set_animation()

	motion = move_and_slide(motion, UP)

func exec_state_idle():
	GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]
	GlobalDictionaries.player_info["Friction"] = true
	if is_on_floor():
		Global.Player["Animation"] = "Idle"
	else:
		if motion.y < 0 and Global.Player["Player_Flags"]["Can_Climb"] == false:
			Global.Player["Animation"] = "Jump"
		else:
			Global.Player["Animation"] = "Fall"

func exec_state_move_right():
	GlobalDictionaries.player_info["Dir_Curr"] = 1
	motion.x = min(motion.x + GlobalDictionaries.player_info["Acceleration"], GlobalDictionaries.player_info["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Jump"
		else:
			Global.Player["Animation"] = "Fall"

func exec_state_move_left():
	GlobalDictionaries.player_info["Dir_Curr"] = -1
	motion.x = max(motion.x - GlobalDictionaries.player_info["Acceleration"], -GlobalDictionaries.player_info["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Jump"
		else:
			Global.Player["Animation"] = "Fall"

func exec_state_move_jump():
	if is_on_floor():
		motion.y = GlobalDictionaries.player_info["JumpHeight"]

func exec_state_spawn_player():
	Global.STATE_LEVEL = "Player_Spawning"
	Global.STATE_PLAYER = "Player_Spawning"
	$AnimationPlayer.play(Global.Player["Name_Explorer"] + "_1_Spawn")

func exec_state_despawn_player():
	Global.STATE_LEVEL = "Player_DeSpawning"
	Global.STATE_PLAYER = "Player_DeSpawning"
	Global.Player["Animation"] = "Exit"
#	var amin_name = player["Name_Explorer"] + "_" + str(GlobalDictionaries.player_info["Dir_Curr"]) + "_Exit"
#	$AnimationPlayer.play(amin_name)
#
func exec_state_open_chest():
	
	Global.Player["Player_Flags"]["Can_OpenChest"] = false
	
	Global.STATE_PLAYER = "Chest_Opening"
	if GlobalDictionaries.player_info["Dir_Curr"] == 0:
		GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]

	if GlobalDictionaries.player_info["Dir_Curr"] == 1:
		Global.Player["Animation"] = "Interact"
	elif  GlobalDictionaries.player_info["Dir_Curr"] == -1:
		Global.Player["Animation"] = "Interact"

func set_player():
	if GlobalDictionaries.players.size() != 0:
		Global.Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
		GlobalDictionaries.player_info = Global.Player["Player_Info"]
	else:
		GlobalDictionaries.players["1"] = GlobalDictionaries.get_new_player_dict("Debug")
		Global.Player = GlobalDictionaries.players["1"]
		Global.Player["Level_Current"] = 0
		GlobalDictionaries.player_info = Global.Player["Player_Info"]
		GlobalDictionaries.game["PlayerKey"] = "1"


func set_animation():

	var anim_name = Global.Player["Name_Explorer"] + "_" + str(GlobalDictionaries.player_info["Dir_Curr"]) + "_" + Global.Player["Animation"]

	if $AnimationPlayer.current_animation != anim_name:
		$AnimationPlayer.play(anim_name)

func _on_AnimationPlayer_animation_finished(anim_name):

	if anim_name.find("Spawn") != -1:
		$AnimationPlayer.play(Global.Player["Name_Explorer"] + "_1_Idle")
		Global.STATE_LEVEL = "Despawn_Portal"
		Global.STATE_PLAYER = "Move_Normal"
	if anim_name.find("_Exit") != -1:
		Global.STATE_LEVEL = "Despawn_Portal_Exit"
	if anim_name.find("_Interact") != -1:
		Global.STATE_PLAYER = "Move_Normal"
#	elif anim_name.find("Scene") != -1:
#		Global.STATE_LEVEL = "Scene_Complete"

#func check_state_play_scene():
#
#	if player["Current_Level"] == 1:
#		if player["Scene_Seen"]["Level1_Enter"] == false:
#			Global.STATE_PLAYER = "Scene_Level1"
#

#
#func exec_state_scene():
#	if Global.STATE_PLAYER == "Scene_Level1":
#		exec_state_scene_level1()
#	elif Global.STATE_PLAYER == "Scene_Level1_2":
#		exec_state_scene_level1_2()
#	elif Global.STATE_PLAYER == "Scene_Level1_Playing" and player["Scene_Seen"]["Level1_Enter"] == true:
#		$SpeechBubble.visible = false
#		Global.STATE_PLAYER = "Move_Normal"
#	elif Global.STATE_PLAYER == "Scene_Level1_2_Playing" and player["Scene_Seen"]["Level1_2"] == true:
#		$SpeechBubble.visible = false
#		Global.STATE_PLAYER = "Move_Normal"


#

#
#
#func exec_state_scene_level1():
#	$AnimationPlayer.play("Scene_Level1_Enter")
#	Global.STATE_PLAYER = "Scene_Level1_Playing"
#
#func exec_state_scene_level1_2():
#	$AnimationPlayer.play("Scene_Level1_2")
#	Global.STATE_PLAYER = "Scene_Level1_2_Playing"


