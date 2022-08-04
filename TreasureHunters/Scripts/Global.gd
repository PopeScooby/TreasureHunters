extends Node

var STATE_GLOBAL = "GameStart"
var STATE_PLAYER = ""
var STATE_LEVEL = ""

func _ready():
	
	load_saves()
	

func new_game(PlayerName):
	
	var NewPlayerKey
	if GlobalDictionaries.players.has("1"):
		NewPlayerKey = GlobalDictionaries.players.size() + 1
	else:
		NewPlayerKey = 1
	
	GlobalDictionaries.game["PlayerKey"] = NewPlayerKey
	GlobalDictionaries.players[str(NewPlayerKey)] = GlobalDictionaries.get_new_player_dict(PlayerName)
	save_game()
	get_tree().change_scene("res://Scenes/Interface/HomeBase.tscn")

func load_level():

	var Level_Suffix = "0" + str(GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Level_Current"])
	GlobalDictionaries.player_info = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Player_Info"]
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

func save_game():
	
	var save_game = File.new()
	var file_name = "user://save_data.save"
	
	save_game.open(file_name, File.WRITE)
	save_game.store_line(to_json(GlobalDictionaries.players))
	save_game.close()

#"2" : {"Coins_Collected": 0,
#	   "Coins": [true, true, true, true, true, true],
#	   "Treasure": true,
#	   "Complete": false
#	},
#"3" : {"Coins_Collected": 0,
#	   "Coins": [true, true, true, true, true, true, true, true, true, true],
#	   "Treasure": true,
#	   "Complete": false
#	},
#"4" : {"Coins_Collected": 0,
#	   "Coins": [true, true, true, true, true, true, true, true, true, true, true, true, true, true],
#	   "Treasure": true,
#	   "Complete": false
#	},
#"5" : {"Coins_Collected": 0,
#	   "Coins": [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
#	   "Treasure": true,
#	   "Complete": false
#	},
#"6" : {"Coins_Collected": 0,
#	   "Coins": [true],
#	   "Treasure": true,
#	   "Complete": false
#	}

