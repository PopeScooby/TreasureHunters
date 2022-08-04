extends KinematicBody2D

const UP = Vector2(0,-1)

var STATES = ["Spawn_Player","Player_Spawning","Move_Normal"]

var player
var player_info

var motion = Vector2(0,0)

func _ready():
	self.visible = false
	set_player()

func _process(delta):
	check_state()
	exec_state()

func check_state():
	if Global.STATE_LEVEL == "Spawn_Player":
		Global.STATE_PLAYER = "Spawn_Player"
	elif Global.STATE_PLAYER == "Play_Scene" and player["Scene_Seen"]["Level1_Enter"] == false:
		Global.STATE_PLAYER = "Scene_Level1"

func exec_state():
	if Global.STATE_PLAYER == "Spawn_Player":
		exec_state_spawn_player()
	elif Global.STATE_PLAYER == "Move_Normal":
		exec_state_move()
	elif Global.STATE_PLAYER.left(5) == "Scene":
		exec_state_scene()

func exec_state_scene():
	if Global.STATE_PLAYER == "Scene_Level1":
		exec_state_scene_level1()
	elif Global.STATE_PLAYER == "Scene_Level1_2":
		exec_state_scene_level1_2()
	elif Global.STATE_PLAYER == "Scene_Level1_Playing" and player["Scene_Seen"]["Level1_Enter"] == true:
		$SpeechBubble.visible = false
		Global.STATE_PLAYER = "Move_Normal"
	elif Global.STATE_PLAYER == "Scene_Level1_2_Playing" and player["Scene_Seen"]["Level1_2"] == true:
		$SpeechBubble.visible = false
		Global.STATE_PLAYER = "Move_Normal"

func exec_state_spawn_player():
	Global.STATE_LEVEL = "Player_Spawning"
	Global.STATE_PLAYER = "Player_Spawning"
	$AnimationPlayer.play(player["Name_Explorer"] + "_1_Spawn")

func exec_state_move():
	
	if GlobalDictionaries.player_info["Dir_Curr"] != 0:
		GlobalDictionaries.player_info["Dir_Prev"] = GlobalDictionaries.player_info["Dir_Curr"]
	
	GlobalDictionaries.player_info["Friction"] = false
	
	motion.y += player_info["Gravity"]
	
	if Input.is_action_just_pressed("interact") and player["Player_Flags"]["Can_OpenChest"] == true:
		player["Player_Flags"]["Can_OpenChest"] = false
		exec_state_open_chest()
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
	player_info["Dir_Curr"] = player_info["Dir_Prev"]
	GlobalDictionaries.player_info["Friction"] = true
	if is_on_floor():
		player["Animation"] = "Idle"
	else:
		if motion.y < 0 and player["Player_Flags"]["Can_Climb"] == false:
			player["Animation"] = "Jump"
		else:
			player["Animation"] = "Fall"

func exec_state_move_right():
	player_info["Dir_Curr"] = 1
	motion.x = min(motion.x+player_info["Acceleration"], player_info["SpeedMax"])
	if is_on_floor():
		player["Animation"] = "Run"
	else:
		if motion.y < 0:
			player["Animation"] = "Jump"
		else:
			player["Animation"] = "Fall"

func exec_state_move_left():
	player_info["Dir_Curr"] = -1
	motion.x = max(motion.x-player_info["Acceleration"], -player_info["SpeedMax"])
	if is_on_floor():
		player["Animation"] = "Run"
	else:
		if motion.y < 0:
			player["Animation"] = "Jump"
		else:
			player["Animation"] = "Fall"

func exec_state_move_jump():
	if is_on_floor():
		motion.y = player_info["JumpHeight"]



func exec_state_open_chest():
	Global.STATE_PLAYER = "Chest_Opening"
	if GlobalDictionaries.player_info["Dir_Curr"] == 0:
		GlobalDictionaries.player_info["Dir_Curr"] = GlobalDictionaries.player_info["Dir_Prev"]
	
	if GlobalDictionaries.player_info["Dir_Curr"] == 1:
		player["Animation"] = "Interact"
	elif  GlobalDictionaries.player_info["Dir_Curr"] == -1:
		player["Animation"] = "Interact"



func exec_state_scene_level1():
	$AnimationPlayer.play("Scene_Level1_Enter")
	Global.STATE_PLAYER = "Scene_Level1_Playing"

func exec_state_scene_level1_2():
	$AnimationPlayer.play("Scene_Level1_2")
	Global.STATE_PLAYER = "Scene_Level1_2_Playing"

func set_animation():
	
	var anim_name = player["Name_Explorer"] + "_" + str(player_info["Dir_Curr"]) + "_" + player["Animation"]
	
	if $AnimationPlayer.current_animation != anim_name:
		$AnimationPlayer.play(anim_name)

func set_player():
	if GlobalDictionaries.players.size() != 0:
		player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
		player_info = player["Player_Info"]
	else:
		player = {"Name": "Debug", 
				 "Name_Explorer": "Inda",
				 "Hearts": 3, 
				 "Hearts_Total": 3,
				 "Coins": 0, 
				 "Coins_Collected": 0,
				 "Treasure": [],
				 "Weapons": [],
				 "Level_Current": 1,
				 "Level_Max": 1,
				 "Level_Timer": 0,
				 "Animation": "",
				 "Levels": {"1" : {"Timer": 120,
								   "Coins_Collected": 0,
								   "Coins": [true, true, true, true],
								   "Chests": [true],
								   "Diamonds": [],
								   "Ruby": [],
								   "Complete": false
								},
							},
				 "Player_Info" : {"Friction": false,
								  "Gravity": 45,
								  "Acceleration": 200,
								  "SpeedMax": 800,
								  "JumpHeight": -1800,
								  "Dir_Curr": 1,
								  "Dir_Prev": 1},
				 "Player_Flags" : {}
					}
		player_info = player["Player_Info"]
		GlobalDictionaries.players["1"] = player
		GlobalDictionaries.player_info = player_info

func _on_AnimationPlayer_animation_finished(anim_name):
	
	if anim_name.find("Spawn") != -1:
		$AnimationPlayer.play(player["Name_Explorer"] + "_1_Idle")
		Global.STATE_LEVEL = "Despawn_Portal"
		Global.STATE_PLAYER = "Move_Normal"
	elif anim_name.find("Scene") != -1:
		Global.STATE_LEVEL = "Scene_Complete"
