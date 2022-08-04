extends StaticBody2D

var STATE = "Closed"

func _ready():
	
	var Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	var Level = Player["Levels"][str(Player["Level_Current"])]
	
#	if Level["Treasure"] == false:
#		STATE = "Opened"
#	else:
#		STATE = "Closed"
	

func _process(delta):
	if Global.STATE_PLAYER == "Chest_Opening" and STATE == "Closed":
		STATE = "Opening"
		$AnimationPlayer.play("Chest_Open")
	elif STATE == "Opened":
		$AnimationPlayer.play("Chest_Opened")
	elif STATE == "Closed":
		$AnimationPlayer.play("Chest_Closed")

func _on_chest_opened():
	
	register_chest()

func register_chest():
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Coins"] += 10
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Coins_Collected"] += 10
	var chest_idx = int(self.name.right(4)) - 1
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Levels"][str(GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Level_Current"])]["Coins_Collected"] += 10
	GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Levels"][str(GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Level_Current"])]["Chests"][chest_idx] = false

func _on_Area2D_body_entered(body):

	var Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	
	if body.name == "Adventurer":
		if body.position.x > self.position.x:
			Player["Player_Flags"]["Crate_R"] = true
		else:
			Player["Player_Flags"]["Crate_R"] = false
		Player["Player_Info"]["Object_Interact"] = self.name
		Player["Player_Flags"]["Can_OpenChest"] = true

func _on_Area2D_body_exited(body):

	var Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	
	if body.name == "Adventurer":
		Player["Player_Flags"]["Can_OpenChest"] = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Chest_Open":
		$AnimationPlayer.play("Chest_Opened")
		_on_chest_opened()
