extends Node

var game = {"PlayerKey": "0"}
var players = {}
var player_info = {}

var items = ["Empty"]

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
					 "Current_Item": "Empty",
					 "Gem_Square": {"Pink": true, "Orange": true, "Green": true, "Blue": true, "Purple": true, "Red": true, "White": true, "Yellow": true},
					 "Items": {"Jumpshroom1": {"InInventory": false, "Level": 0, "Pos": Vector2(0,0)}, 
							   "Jumpshroom2": {"InInventory": false, "Level": 0, "Pos": Vector2(0,0)}, 
							   "Handle1": {"InInventory": false, "Level": 0, "Lever_Base": ""}},
					 "Inventory": {"Jumpshroom": 0, "Crate": 0},
					 "Levels": {"0" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [false],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "GotPerfect": false, 
									   "Perfect_Time": null,
									   "Gem_Square": ""
									},
								"1" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "GotPerfect": false, 
									   "Perfect_Time": null,
									   "Gem_Square": "Pink"
									},
								"2" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "GotPerfect": false, 
									   "Perfect_Time": null,
									   "Gem_Square": "Orange"
									},
								"3" : {"Timer": 120,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "GotPerfect": false, 
									   "Perfect_Time": null,
									   "Gem_Square": "Green"
									},
								"4" : {"Timer": 180,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "GotPerfect": false, 
									   "Perfect_Time": null,
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
									   "GotPerfect": false, 
									   "Perfect_Time": null,
									   "Heart_Container": false
									},
								"6" : {"Timer": 240,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": "Red",
									   "GotPerfect": false, 
									   "Perfect_Time": null,
									   "Heart_Container": false
									},
								"7" : {"Timer": 300,
									   "Coins_Collected": 0,
									   "Coins": [true],
									   "Chests": [true],
									   "Diamonds": [],
									   "Ruby": [],
									   "Complete": false,
									   "Gem_Square": "White",
									   "GotPerfect": false, 
									   "Perfect_Time": null,
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
									   "On_Hospital": false,
									   "Can_PullLever": false,
									   "On_Crate": false,
									   "On_MushRoom": false,
									   "Near_LeverBase": false},
					 "Interactions": {"Jumpshroom": {"BounceHeight": 0}},
					 "Scenes": {"Scene_Curr":{ "SceneName": ""},
								"Homebase_Intro_01": {"Seen": false, "Next": "Homebase_Intro_02", "Parent":"Homebase"},
								"Homebase_Intro_02": {"Seen": false, "Next": "Homebase_Intro_03", "Parent":"Homebase"},
								"Homebase_Intro_03": {"Seen": false, "Next": "Homebase_Intro_04", "Parent":"Homebase"},
								"Homebase_Intro_04": {"Seen": false, "Next": "Homebase_Intro_05", "Parent":"Homebase"},
								"Homebase_Intro_05": {"Seen": false, "Next": "Homebase_Intro_06", "Parent":"Homebase"},
								"Homebase_Intro_06": {"Seen": false, "Next": "Homebase_Intro_07", "Parent":"Homebase"},
								"Homebase_Intro_07": {"Seen": false, "Next": "Homebase_Intro_08", "Parent":"Homebase"},
								"Homebase_Intro_08": {"Seen": false, "Next": "", "Parent":"Homebase"},
								"Homebase_Intro_09": {"Seen": false, "Next": "Homebase_Intro_10", "Parent":"Homebase"},
								"Homebase_Intro_10": {"Seen": false, "Next": "", "Parent":"Homebase"},
								"Level_01_Enter": {"Seen": false, "Next": "Level_01_Radio_01", "Parent":"Adventurer"},
								"Level_01_Radio_01": {"Seen": false, "Next": "Level_01_Radio_02", "Parent":"GameplayInterface"},
								"Level_01_Radio_02": {"Seen": false, "Next": "", "Parent":"GameplayInterface"},
								"Level_01_2": {"Seen": false, "Next": "", "Parent":"Adventurer"},
								"Level_02_Enter_01": {"Seen": false, "Next": "Level_02_Enter_02", "Parent":"Adventurer"},
								"Level_02_Enter_02": {"Seen": false, "Next": "Level_02_Enter_03", "Parent":"Adventurer"},
								"Level_02_Enter_03": {"Seen": false, "Next": "Level_02_Enter_04", "Parent":"GameplayInterface"},
								"Level_02_Enter_04": {"Seen": false, "Next": "", "Parent":"GameplayInterface"},
								"Level_05_HospitalFound": {"Seen": false, "Next": "", "Parent":"Adventurer"},
								"Level_07_MushRoomFound": {"Seen": false, "Next": "", "Parent":"Adventurer"}}
				}
	
	return NewPlayer


#					 "Items": {"Jumpshroom1": {"InInventory": true, "Level": 0, "Pos": Vector2(0,0)}, 
#							   "Jumpshroom2": {"InInventory": false, "Level": 0, "Pos": Vector2(0,0)}},

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
									   "On_Hospital": false,
									   "Can_PullLever": false,
									   "On_Crate": false,
									   "On_MushRoom": false,
									   "Near_LeverBase": false}
