extends Area2D


func _ready():
	pass 

func _on_Coin_body_entered(body):
	if body.name == "Adventurer":
		register_coin()
		queue_free()

func register_coin():
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Coins"] += 1
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Coins_Collected"] += 1
	var coin_idx = int(self.name.right(4)) - 1
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Levels"][str(GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Level_Current"])]["Coins_Collected"] += 1
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Levels"][str(GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Level_Current"])]["Coins"][coin_idx] = false
	
#
#	var NewPlayer = {"Name": get_node("Menu_NewGame/NewNameTxt").text, 
#					 "Hearts": 3, 
#					 "Hearts_Total": 3,
#					 "Coins": 0, 
#					 "Coins_Collected": 0,
#					 "Wands": {},
#					 "Level_Current": 1,
#					 "Level_Max": 1,
#					 "Levels": {"1" : {"Coins_Collected": 0,
#									   "Coins": [true, true, true, true],
#									   "Wands": {"Wand_Stick": true}
#									}
#								},
#					 "Player_Info" : {"Friction": false,
#									  "Motion": Vector2.ZERO,
#									  "Gravity": 45,
#									  "Acceleration": 200,
#									  "SpeedMax": 800,
#									  "JumpHeight": -1700,
#									  "Dir_Curr": 1,
#									  "Dir_Prev": 1}
#					}
