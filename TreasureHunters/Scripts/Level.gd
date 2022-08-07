extends Node2D

var STATES = ["Spawn_Protal","Portal_Spawning","Spawn_Player","Player_Spawning","Despawn_Portal","Gameplay","Despawn_Portal_Exit",
			  "Scene_Level1","Scene_Complete"]

export var cam_left = 0
export var cam_right = 0
export var cam_top = 0
export var cam_bottom = 0

var level
var level_num

func _ready():

	if Global.isDebug == true:
		GlobalDictionaries.players["1"] = GlobalDictionaries.get_new_player_dict("Debug")
		Global.Player = GlobalDictionaries.players["1"]
		Global.Player["Level_Current"] = 0
		GlobalDictionaries.player_info = Global.Player["Player_Info"]
		GlobalDictionaries.game["PlayerKey"] = "1"
	if GlobalDictionaries.game["PlayerKey"] == "0":
		GlobalDictionaries.game["PlayerKey"] = "1"

	$Adventurer/Camera2D.limit_left = cam_left
	$Adventurer/Camera2D.limit_right = cam_right
	$Adventurer/Camera2D.limit_top = cam_top
	$Adventurer/Camera2D.limit_bottom = cam_bottom
	level_setup()	
	Global.STATE_LEVEL = "Spawn_Portal"
#	level = 

func _process(delta):
	check_state()
	exec_state()
	

func check_state():
	pass

func exec_state():
	if Input.is_action_just_pressed("menu_select") and $GameplayInterface/Continue.visible == true:
		exec_state_complete()
	elif Global.STATE_LEVEL == "Play_Scene":
		exec_state_play_scene()
	elif Global.STATE_LEVEL == "Scene_Complete":
		exec_state_scene_complete()
	
	
func exec_state_play_scene():
#
#	if player["Scene_Seen"]["Level1_Enter"] == false:
		$GameplayInterface/Timer/LevelTimeTimer.stop()
#		Global.STATE_LEVEL = "Scene_Level1"

func exec_state_scene_complete():
	$GameplayInterface/Continue.visible = true

func exec_state_complete():
	if Global.STATE_PLAYER == "Scene_Level1_Playing":
		$GameplayInterface/Continue.visible = false
		Global.Player["Scene_Seen"]["Level1_Enter"] = true
		$GameplayInterface/Timer/LevelTimeTimer.start()
		Global.STATE_LEVEL = "Spawn_Portal_Exit"
	elif Global.STATE_PLAYER == "Scene_Level1_2_Playing":
		$GameplayInterface/Continue.visible = false
		Global.Player["Scene_Seen"]["Level1_2"] = true
		$GameplayInterface/Timer/LevelTimeTimer.start()
		Global.STATE_LEVEL = "Spawn_Portal_Exit"

func level_setup():
#
#	player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	level_num = int(self.name.replace("Level_", ""))
	level = Global.Player["Levels"][str(level_num)]
	
#	level_setup_timer()
	level_setup_coins(level)
#	level_setup_chests(level)

func level_setup_timer():
	Global.Player["Level_Timer"] = level["Timer"]
	$GameplayInterface/Timer/LevelTimeTimer.start()

func level_setup_coins(Level):
	
	var level_coins_count = get_tree().get_nodes_in_group("Coins").size()
	var dict_coins_count = Level["Coins"].size()
	var Coin_Curr = 1
	
	if level_coins_count != dict_coins_count:
		Level["Coins"] = []
		while Coin_Curr <= level_coins_count:
			Level["Coins"].append(true)
			Coin_Curr += 1
	
	var Coins = Level["Coins"]
	Coin_Curr = 1
	
	while Coin_Curr <= level_coins_count:
		get_node("Treasure/Coin" + str(Coin_Curr)).visible = Coins[Coin_Curr - 1]
		Coin_Curr += 1

func level_setup_chests(Level):
	
	var Chests = Level["Chests"]
	var Chest_Max = Level["Chests"].size()
	var Chest_Curr = 1
	
	while Chest_Curr <= Chest_Max:
		if Chests[Chest_Curr - 1]:
			get_node("Treasure/Chest" + str(Chest_Curr) + "/AnimationPlayer").play("Chest_Opened")
		else:
			get_node("Treasure/Chest" + str(Chest_Curr) + "/AnimationPlayer").play("Chest_Closed")
		Chest_Curr += 1

