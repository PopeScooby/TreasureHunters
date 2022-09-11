extends Node

#var isDebug = false

var Player
var Level

var hearts_total = 0
var hearts = 0
var coins_total = 0
var coins_collected_total = 0
var coins_collected_level = 0
var coins = []
var chests = []
var diamonds = []
var ruby = []
var heart_container = false
var gem_square_count = 0
var gem_square
var items = {"Jumpshroom1": {"InInventory": false, "Level": "", "Pos": Vector2(0,0)}, 
			 "Jumpshroom2": {"InInventory": false, "Level": "", "Pos": Vector2(0,0)}}

var STATE_GLOBAL = "GameStart"
var STATE_PLAYER = ""
var STATE_LEVEL = ""

func _ready():
	
	load_saves()

func _process(delta):
	pass

func new_game(PlayerName):
	
	var NewPlayerKey
	if GlobalDictionaries.players.has("1"):
		NewPlayerKey = str(GlobalDictionaries.players.size() + 1)
	else:
		NewPlayerKey = "1"
	
	GlobalDictionaries.game["PlayerKey"] = NewPlayerKey
	GlobalDictionaries.players[str(NewPlayerKey)] = GlobalDictionaries.get_new_player_dict(PlayerName)
	save_game()
	Player = GlobalDictionaries.players[NewPlayerKey]
	get_tree().change_scene("res://Scenes/Interface/HomeBase.tscn")

func load_level():

	var Level_Suffix = "0" + str(Global.Player["Level_Current"])
	GlobalDictionaries.player_info = Global.Player["Player_Info"]
	GlobalDictionaries.reset_flags(Global.Player["Level_Current"])
	get_tree().change_scene("res://Scenes/Levels/Level_" + Level_Suffix + ".tscn")

func load_saves():
	
	var save_game = File.new()
	var file_name = "user://save_data.save"
	if not save_game.file_exists(file_name):
		return
	
	save_game.open(file_name, File.READ)
	GlobalDictionaries.players.clear()
#	while not save_game.eof_reached():
#		var current_line = parse_json(save_game.get_line())
#		if current_line!= null:
#			GlobalDictionaries.players = current_line

	save_game.close()

func reset_level_variables():
	
	hearts_total = Global.Player["Hearts_Total"]
	hearts = Global.Player["Hearts"]
	coins_total = Global.Player["Coins"]
	coins_collected_total = Global.Player["Coins_Collected"]
	coins_collected_level = Global.Level["Coins_Collected"]
	gem_square_count = Global.Player["Gem_Square_Count"]
	if Global.Level["Gem_Square"] != "":
		gem_square = Global.Player["Gem_Square"][Global.Level["Gem_Square"]]
	coins = []
	chests = []
	diamonds = []
	ruby = []
	items["Jumpshroom1"] = Global.Player["Items"]["Jumpshroom1"]
	items["Jumpshroom2"] = Global.Player["Items"]["Jumpshroom2"]
	if Global.Level.has("Heart_Container"):
		heart_container = Global.Level["Heart_Container"]
	else:
		heart_container = false
	
	var curr_idx = 0
	while curr_idx < Global.Level["Coins"].size():
		coins.append(Global.Level["Coins"][curr_idx])
		curr_idx += 1
	
	curr_idx = 0
	while curr_idx < Global.Level["Chests"].size():
		chests.append(Global.Level["Chests"][curr_idx])
		curr_idx += 1
		
	curr_idx = 0
	while curr_idx < Global.Level["Diamonds"].size():
		diamonds.append(Global.Level["Diamonds"][curr_idx])
		curr_idx += 1
	
	curr_idx = 0
	while curr_idx < Global.Level["Ruby"].size():
		ruby.append(Global.Level["Ruby"][curr_idx])
		curr_idx += 1

func save_level_variables():
	
	if Global.Level["Coins_Collected"] == 0 and coins_collected_level == (coins.size() + (chests.size() * 10)) :
		Global.Level["GotPerfect"] = true
		var seconds_used = Global.Level["Timer"] - Global.Player["Level_Timer"] 
		Global.Level["Perfect_Time"] = str(floor(seconds_used / 60)) + ":" + str(seconds_used - (floor(seconds_used / 60) * 60))
	
	Global.Player["Hearts_Total"] = hearts_total
	Global.Player["Hearts"] = hearts
	Global.Player["Coins"] = coins_total 
	Global.Player["Coins_Collected"] = coins_collected_total 
	Global.Level["Coins_Collected"] = coins_collected_level 
	Global.Level["Gem_Square_Count"] = gem_square_count 
	if Global.Level["Gem_Square"] != "":
		Global.Player["Gem_Square"][Global.Level["Gem_Square"]] = gem_square 
	Global.Level["Coins"] = []
	Global.Level["Chests"] = []
	Global.Level["Diamonds"] = []
	Global.Level["Ruby"] = []
	Global.Player["Items"]["Jumpshroom1"] = items["Jumpshroom1"]
	Global.Player["Items"]["Jumpshroom2"] = items["Jumpshroom2"] 
	if Global.Level.has("Heart_Container"):
		Global.Level["Heart_Container"] = heart_container 
	
	var curr_idx = 0
	while curr_idx < coins.size():
		Global.Level["Coins"].append(coins[curr_idx])
		curr_idx += 1
		
	curr_idx = 0
	while curr_idx < chests.size():
		Global.Level["Chests"].append(chests[curr_idx])
		curr_idx += 1
		
	curr_idx = 0
	while curr_idx < diamonds.size():
		Global.Level["Diamonds"].append(diamonds[curr_idx])
		curr_idx += 1
	
	curr_idx = 0
	while curr_idx < ruby.size():
		Global.Level["Ruby"].append(ruby[curr_idx])
		curr_idx += 1

func save_game():
	
	var save_game = File.new()
	var file_name = "user://save_data.save"
	
	save_game.open(file_name, File.WRITE)
	save_game.store_line(to_json(GlobalDictionaries.players))
	save_game.close()

func place_jumpshroom(ItemsNode, JumpshroomName):
	var jumpshroom = load("res://Scenes/Items/Jumpshroom.tscn").instance()
	jumpshroom.position = Global.items[JumpshroomName]["Pos"]
	jumpshroom.scale = Vector2(2,2)
	jumpshroom.BounceHeight = -3000
	ItemsNode.add_child(jumpshroom)
