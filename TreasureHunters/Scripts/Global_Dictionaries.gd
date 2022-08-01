extends Node

var game = {"PlayerKey": "0"}
var players = {}
var player_info = {}

func _ready():
	pass # Replace with function body.


func get_new_player_dict(PlayerName):

	var NewPlayer = {"Name": PlayerName, 
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
									   "Coins": [true],
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
					 "Player_Flags" : {"Can_Climb": false,
									   "On_Exit": false,
									   "Can_OpenChest": false},
					 "Scene_Seen": {"New_Game": false,
									"Level1_Enter": false,
									"Level1_2": false}
				}
	
	return NewPlayer
