extends Node

var game = {"PlayerKey": "0"}
var players = {}
var player_info = {}

func _ready():
	pass # Replace with function body.


func get_new_player_dict(PlayerName):

	var NewPlayer = {"Name": PlayerName, 
					 "Name_Explorer": "",
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
					 "Animation2": "",
					 "Gem_Square_Count": 0,
					 "Gem_Square": {"Pink": true, "Orange": true, "Green": true, "Blue": true, "Purple": true},
					 "Levels": {"0" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [false],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": ""
									},
								"1" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": "Pink"
									},
								"2" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": "Orange"
									},
								"3" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": "Green"
									},
								"4" : {"Timer": 180,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": "Blue"
									},
								"5" : {"Timer": 240,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": "Purple",
									   "Heart_Container": false
									}
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
									   "Can_OpenChest": false,
									   "Can_Push": false,
									   "Crate_R": false,
									   "On_Elevator": false,
									   "On_Vines": false,
									   "On_Enemy": false,
									   "On_Spikes": false,
									   "On_Hospital": false},
					 "Interactions": {"Jumpshroom": {"BounceHeight": 0}},
					 "Scenes": {"Scene_Curr":{ "SceneName": ""},
								"Homebase_Intro_01": {"Seen": false, "Next": "Homebase_Intro_02"},
								"Homebase_Intro_02": {"Seen": false, "Next": "Homebase_Intro_03"},
								"Homebase_Intro_03": {"Seen": false, "Next": "Homebase_Intro_04"},
								"Homebase_Intro_04": {"Seen": false, "Next": "Homebase_Intro_05"},
								"Homebase_Intro_05": {"Seen": false, "Next": "Homebase_Intro_06"},
								"Homebase_Intro_06": {"Seen": false, "Next": "Homebase_Intro_07"},
								"Homebase_Intro_07": {"Seen": false, "Next": "Homebase_Intro_08"},
								"Homebase_Intro_08": {"Seen": false, "Next": ""},
								"Homebase_Intro_09": {"Seen": false, "Next": "Homebase_Intro_10"},
								"Homebase_Intro_10": {"Seen": false, "Next": ""},
								"Level_01_Enter": {"Seen": false, "Next": ""},
								"Level_01_2": {"Seen": false, "Next": ""},
								"Level_05_HospitalFound": {"Seen": false, "Next": ""}}
				}
	
	return NewPlayer

func reset_flags(LevelNum):
	Global.Player["Player_Flags"] =  {"Can_Climb": false,
									   "On_Exit": false,
									   "Can_OpenChest": false,
									   "Can_Push": false,
									   "Crate_R": false,
									   "On_Elevator": false,
									   "On_Vines": false,
									   "On_Enemy": false,
									   "On_Spikes": false,
									   "On_Hospital": false}
