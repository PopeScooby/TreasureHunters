extends KinematicBody2D

const UP = Vector2(0,-1)

var STATES = ["Spawn_Player","Player_Spawning","Move_Normal"]

var motion = Vector2(0,0)

func _ready():
	self.visible = false
	$SpeechBubble.visible = false
	set_player()

func _process(delta):
	
	check_state()
	exec_state()

func check_state():
	if Global.hearts <= 0 and Global.STATE_PLAYER != "Dead":
		Global.STATE_PLAYER = "Dying"
	elif Global.STATE_PLAYER == "InWater":
		Global.STATE_PLAYER = "Dying"
	elif Global.STATE_LEVEL == "Spawn_Player":
		Global.STATE_PLAYER = "Spawn_Player"
	elif Global.STATE_PLAYER == "OnCrate":
		Global.Player["Player_Flags"]["Can_Push"] = true
		Global.STATE_PLAYER = "Move_Normal"
	elif Global.STATE_PLAYER == "OffCrate":
		Global.Player["Player_Flags"]["Can_Push"] = false
		Global.STATE_PLAYER = "Move_Normal"


func exec_state():
	if Global.STATE_PLAYER == "Spawn_Player":
		exec_state_spawn_player()
	elif Global.STATE_PLAYER == "Start_Scene":
		exec_state_start_scene()
	elif Global.STATE_PLAYER == "Complete_Scene":
		exec_state_complete_scene()
	elif Global.STATE_PLAYER == "Dying":
		exec_state_dying()
	elif Global.STATE_PLAYER == "Bounce":
		exec_state_bounce()
	elif Global.STATE_PLAYER == "Move_Normal" and Global.Player["Player_Flags"]["On_Enemy"] == true:
		Global.Player["Player_Flags"]["On_Enemy"] = false
		exec_state_damage()
	elif Global.STATE_PLAYER == "Move_Normal" and Global.Player["Player_Flags"]["On_Spikes"] == true:
		Global.Player["Player_Flags"]["On_Spikes"] = false
		exec_state_damage()
	elif Global.STATE_PLAYER == "Move_Normal" and Global.Player["Player_Flags"]["On_Vines"] == false:
		exec_state_move()
	elif Global.STATE_PLAYER == "Move_Normal" and Global.Player["Player_Flags"]["On_Vines"] == true:
		exec_state_move_vines()

func exec_state_move():
	
	if GlobalDictionaries.player_info["Dir_Curr"] != 0:
		GlobalDictionaries.player_info["Dir_Prev"] = GlobalDictionaries.player_info["Dir_Curr"]

	GlobalDictionaries.player_info["Friction"] = false

	motion.y += GlobalDictionaries.player_info["Gravity"]

	if Input.is_action_just_pressed("action_interact") and Global.Player["Player_Flags"]["Can_OpenChest"] == true:
		exec_state_open_chest()
	elif Input.is_action_just_pressed("action_interact") and Global.Player["Player_Flags"]["On_Exit"] == true:
		exec_state_despawn_player()
	elif Global.Player["Player_Flags"]["Can_Push"] == true:
		exec_state_push()
	elif Input.is_action_pressed("move_right"):
		exec_state_move_right()
	elif Input.is_action_pressed("move_left"):
		exec_state_move_left()
	elif Input.is_action_pressed("move_down") and is_on_floor():
		exec_state_move_crouch()
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
			if  Global.Player["Player_Flags"]["On_Elevator"] == false:
				Global.Player["Animation"] = "Fall"
			else:
				Global.Player["Animation"] = "Idle"

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

func exec_state_move_crouch():

	if GlobalDictionaries.player_info["Dir_Curr"] == 0:
		GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]

	GlobalDictionaries.player_info["Friction"] = true
	Global.Player["Animation"] = "Crouch"
#	Global.Player["Animation2"] = "Camera_Crouch"

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

func exec_state_open_chest():
	
	Global.Player["Player_Flags"]["Can_OpenChest"] = false
	
	Global.STATE_PLAYER = "Chest_Opening"
	if GlobalDictionaries.player_info["Dir_Curr"] == 0:
		GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]

	if GlobalDictionaries.player_info["Dir_Curr"] == 1:
		Global.Player["Animation"] = "Interact"
	elif  GlobalDictionaries.player_info["Dir_Curr"] == -1:
		Global.Player["Animation"] = "Interact"

func exec_state_push():
	
	if Input.is_action_pressed("move_right"):
		exec_state_push_right()
	elif Input.is_action_pressed("move_left"):
		exec_state_push_left()
	else:
		exec_state_push_idle()

func exec_state_push_right():
	GlobalDictionaries.player_info["Dir_Curr"] = 1
	motion.x = min(motion.x + GlobalDictionaries.player_info["Acceleration"], GlobalDictionaries.player_info["SpeedMax"])
	if Global.Player["Player_Flags"]["Crate_R"]:
		Global.Player["Animation"] = "Pull"
	else:
		Global.Player["Animation"] = "Push"

func exec_state_push_left():
	GlobalDictionaries.player_info["Dir_Curr"] = -1
	motion.x = max(motion.x - GlobalDictionaries.player_info["Acceleration"], -GlobalDictionaries.player_info["SpeedMax"])
	if Global.Player["Player_Flags"]["Crate_R"]:
		Global.Player["Animation"] = "Push"
	else:
		Global.Player["Animation"] = "Pull"

func exec_state_push_idle():
	GlobalDictionaries.player_info["Dir_Curr"] = -1
	motion.x = max(motion.x - GlobalDictionaries.player_info["Acceleration"], -GlobalDictionaries.player_info["SpeedMax"])
	if Global.Player["Player_Flags"]["Crate_R"]:
		Global.Player["Animation"] = "Idle"
	else:
		Global.Player["Animation"] = "Idle"

func exec_state_bounce():
	motion.y = Global.Player["Interactions"]["Jumpshroom"]["BounceHeight"]
	Global.STATE_PLAYER = "Move_Normal"

func exec_state_dying():
	motion.x = 0
	Global.Player["Animation"] = "Die"
	set_animation()

func exec_state_move_vines():

	if GlobalDictionaries.player_info["Dir_Curr"] != 0:
		GlobalDictionaries.player_info["Dir_Prev"] = GlobalDictionaries.player_info["Dir_Curr"]

	GlobalDictionaries.player_info["Friction"] = false
#
#	motion.y += GlobalDictionaries.player_info["Gravity"]

	if Input.is_action_pressed("move_right"):
		exec_state_move_right_vines()
	elif Input.is_action_pressed("move_left"):
		exec_state_move_left_vines()
	elif Input.is_action_pressed("move_up"):
		exec_state_move_up_vines()
	elif Input.is_action_pressed("move_down"):
		exec_state_move_down_vines()
	else:
		exec_state_idle_vines()
#
#	if Input.is_action_just_pressed("move_jump"):
#		exec_state_move_jump_vines()

	set_animation()

	motion = move_and_slide(motion, UP)

func exec_state_move_right_vines():
	GlobalDictionaries.player_info["Dir_Curr"] = 1
	motion.x = min(motion.x + GlobalDictionaries.player_info["Acceleration"], GlobalDictionaries.player_info["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

func exec_state_move_left_vines():
	GlobalDictionaries.player_info["Dir_Curr"] = -1
	motion.x = max(motion.x - GlobalDictionaries.player_info["Acceleration"], -GlobalDictionaries.player_info["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

func exec_state_move_up_vines():
	GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]
	motion.y = max(motion.x - GlobalDictionaries.player_info["Acceleration"] * 1.5, -GlobalDictionaries.player_info["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

func exec_state_move_down_vines():
	GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]
	motion.y = min(motion.x + GlobalDictionaries.player_info["Acceleration"] * 3, GlobalDictionaries.player_info["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Idle"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

func exec_state_move_jump_vines():
	motion.y = GlobalDictionaries.player_info["JumpHeight"] * 15

func exec_state_idle_vines():
	GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]
	motion.y = 0
	motion.x = 0
	if is_on_floor():
		Global.Player["Animation"] = "Idle"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "VinesIdle"
		else:
			Global.Player["Animation"] = "VinesIdle"

func exec_state_damage():
	
	if Global.hearts > 0:
		Global.hearts -= 1
		$AnimationPlayer2.play("Damage")
	else:
		Global.STATE_PLAYER = "Dying"

func exec_state_start_scene():
	
	var anim_name = "Scene_" + Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
	
	$AnimationPlayer2.play(anim_name)

func exec_state_continue_scene():
	$AnimationPlayer2.stop()

func exec_state_complete_scene():
	$SpeechBubble.visible = false
	Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Seen"] = true
	Global.STATE_PLAYER = "Move_Normal"


func set_player():
	if GlobalDictionaries.players.size() != 0:
		Global.Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
		GlobalDictionaries.player_info = Global.Player["Player_Info"]
	else:
		GlobalDictionaries.players["1"] = GlobalDictionaries.get_new_player_dict("Debug")
		Global.Player = GlobalDictionaries.players["1"]
		Global.Player["Level_Current"] = int(get_parent().name.replace("Level_",""))
		GlobalDictionaries.player_info = Global.Player["Player_Info"]
		GlobalDictionaries.game["PlayerKey"] = "1"


func set_animation():
	
	if Global.Player["Animation"] == "VinesIdle":
		$AnimationPlayer.playback_speed = 0
	else:
		$AnimationPlayer.playback_speed = 1
		var anim_name = Global.Player["Name_Explorer"] + "_" + str(GlobalDictionaries.player_info["Dir_Curr"]) + "_" + Global.Player["Animation"]

		if $AnimationPlayer.current_animation != anim_name:
			$AnimationPlayer.play(anim_name)

#	if Global.Player["Animation"] != "Crouch" and Global.Player["Animation2"] == "Camera_Crouch":
#		Global.Player["Animation2"] = "Camera_Stand"
#
#	var anim_name = Global.Player["Animation2"]
#	var anim_curr = $AnimationPlayer2.current_animation
#	if anim_curr != anim_name:
#		$AnimationPlayer2.play(anim_name)

func _on_AnimationPlayer_animation_finished(anim_name):

	if anim_name.find("Spawn") != -1:
		$AnimationPlayer.play(Global.Player["Name_Explorer"] + "_1_Idle")
		Global.STATE_LEVEL = "Despawn_Portal"
		Global.STATE_PLAYER = "Move_Normal"
	if anim_name.find("_Exit") != -1:
		Global.STATE_LEVEL = "Despawn_Portal_Exit"
	if anim_name.find("_Interact") != -1:
		Global.STATE_PLAYER = "Move_Normal"
	if anim_name.find("_Die") != -1:
		Global.STATE_PLAYER = "Dead"
	elif anim_name.find("Scene") != -1:
		Global.STATE_GLOBAL = "Continue_Scene"




