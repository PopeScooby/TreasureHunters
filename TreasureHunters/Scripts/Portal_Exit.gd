extends Area2D


func _ready():
	self.visible = false

func _process(delta):
	check_state()
	exec_state()
	
func check_state():
	if GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Level_Timer"] <= 0:
		Global.STATE_LEVEL = "Timeout"
		
func exec_state():

	if Global.STATE_LEVEL == "Spawn_Portal_Exit":
		$AnimationPlayer.play("Portal_Spawn")
		Global.STATE_LEVEL = "Portal_Exit_Spawning"
	elif Global.STATE_LEVEL == "Despawn_Portal_Exit":
		$AnimationPlayer.play("Portal_Close")
		Global.STATE_LEVEL = "Gameplay"
	elif Global.STATE_LEVEL == "Timeout":
		$AnimationPlayer.play("Portal_Close")
#		Global.STATE_LEVEL = "Gameplay"

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Portal_Spawn":
		$AnimationPlayer.play("Portal_Idle")
	elif anim_name == "Portal_Close":
		self.visible = false
#		if Global.players[str(Global.game["PlayerKey"])]["Scene_Seen"]["Level1_Enter"] == false:
#			Global.STATE_LEVEL = "Play_Scene"
#			Global.STATE_PLAYER = "Play_Scene"



#func _on_AnimationPlayer_animation_finished(anim_name):
#
#	var Player = Global.players[str(Global.game["PlayerKey"])]
#	var Level = Player["Levels"][str(Player["Level_Current"])]
#
#	if anim_name == "Portal_Spawn":
#		$AnimationPlayer.play("Portal_Idle")
#	elif anim_name == "Portal_Close":
#		if Player["Level_Current"] == Player["Level_Max"] and Player["Level_Current"] != Player["Levels"].size():
#			Player["Level_Max"] += 1
#		Level["Complete"] = true
#		Global.save_game()
#		get_tree().change_scene("res://Scenes/Interface/Menu_LevelSelect.tscn")


func _on_Portal_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Player_Flags"]["OnExit"] = true


func _on_Portal_body_exited(body):
	if body.name == "Adventurer" and self.visible == true:
		GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Player_Flags"]["OnExit"] = false
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
#									   "Wands": {"Wand_Stick": true},
#									   "Complete": false
#									},
#								"2" : {"Coins_Collected": 0,
#									   "Coins": [true, true, true, true, true, true],
#									   "Wands": {"Wand_Wood": true},
#									   "Complete": false
#									}
#								},
#					 "Player_Info" : {"Friction": false,
#									  "Gravity": 45,
#									  "Acceleration": 200,
#									  "SpeedMax": 800,
#									  "JumpHeight": -1700,
#									  "Dir_Curr": 1,
#									  "Dir_Prev": 1}
#					}
