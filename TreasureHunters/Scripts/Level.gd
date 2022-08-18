extends Node2D

var STATES = ["Spawn_Protal","Portal_Spawning","Spawn_Player","Player_Spawning","Despawn_Portal","Gameplay","Despawn_Portal_Exit",
			  "Scene_Level1","Scene_Complete"]

export var cam_left = 0
export var cam_right = 0
export var cam_top = 0
export var cam_bottom = 0

var level_num



func _ready():

	if Global.isDebug == true:
		GlobalDictionaries.players["1"] = GlobalDictionaries.get_new_player_dict("Debug")
		Global.Player = GlobalDictionaries.players["1"]
		Global.Player["Level_Current"] = int(self.name.replace("Level_",""))
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
 

func _process(delta):
	check_state()
	exec_state()
	

func check_state():
	if Global.Player["Level_Timer"] == 0:
		get_tree().paused = true

func exec_state():
	if Input.is_action_just_pressed("menu_select") and $GameplayInterface/Continue.visible == true:
		exec_state_continuing_scene()
	elif Global.STATE_LEVEL == "Playing_Scene":
		exec_state_playing_scene()
	elif Global.STATE_LEVEL == "Continue_Scene":
		exec_state_continue_scene()
	elif Global.STATE_LEVEL == "Complete_Scene":
		exec_state_complete_scene()
	
	
func exec_state_playing_scene():
	$GameplayInterface/Timer/LevelTimeTimer.stop()

func exec_state_continue_scene():
	$GameplayInterface/Continue.visible = true
	Global.STATE_PLAYER = "Waiting"

func exec_state_continuing_scene():
	$GameplayInterface/Continue.visible = false
	Global.STATE_GLOBAL = "Continuing_Scene"

func exec_state_complete_scene():
	$GameplayInterface/Timer/LevelTimeTimer.start()
	Global.STATE_GLOBAL = "Gameplay"
	Global.STATE_LEVEL = "Gameplay"
	get_node("Adventurer")


func level_setup():

	level_num = int(self.name.replace("Level_", ""))
	Global.Level = Global.Player["Levels"][str(level_num)]
	
	level_setup_timer()
	level_setup_coins()
	level_setup_chests()
	
	Global.reset_level_variables()

func level_setup_timer():
	Global.Player["Level_Timer"] = Global.Level["Timer"]
	$GameplayInterface/Timer/LevelTimeTimer.start()

func level_setup_coins():
	
	var level_coins_count = get_tree().get_nodes_in_group("Coins").size()
	var dict_coins_count = Global.Level["Coins"].size()
	var Coin_Curr = 1
	
	if level_coins_count != dict_coins_count:
		Global.Level["Coins"] = []
		while Coin_Curr <= level_coins_count:
			Global.Level["Coins"].append(true)
			Coin_Curr += 1
	
	var Coins = Global.Level["Coins"]
	Coin_Curr = 1
	
	while Coin_Curr <= level_coins_count:
		get_node("Treasure/Coin" + str(Coin_Curr)).visible = Coins[Coin_Curr - 1]
		Coin_Curr += 1

func level_setup_chests():
	
	var Chests = Global.Level["Chests"]
	var Chest_Max = Global.Level["Chests"].size()
	var Chest_Curr = 1
	
	while Chest_Curr <= Chest_Max:
		if Chests[Chest_Curr - 1]:
			get_node("Treasure/Chest" + str(Chest_Curr)).STATE = "Closed"
#			get_node("Treasure/Chest" + str(Chest_Curr) + "/AnimationPlayer").play("Chest_Closed")
		else:
			get_node("Treasure/Chest" + str(Chest_Curr)).STATE = "Opened"
#			get_node("Treasure/Chest" + str(Chest_Curr) + "/AnimationPlayer").play("Chest_Opened")
		Chest_Curr += 1

