extends StaticBody2D

var STATE = "Closed"

func _ready():
	
	self.add_to_group("Chests")
#
#	if Global.Level["Treasure"] == false:
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
	
	Global.Player["Coins"] += 10
	Global.Player["Coins_Collected"] += 10
	var chest_idx = int(self.name.right(4)) - 1
	Global.Level["Coins_Collected"] += 10
	Global.Level["Chests"][chest_idx] = false

func _on_Area2D_body_entered(body):
	
	var chest_name = self.name
	var chest_idx = int(chest_name.replace("Chest","")) - 1
	
	if body.name == "Adventurer" and Global.Level["Chests"][chest_idx] == true:
		if body.position.x > self.position.x:
			Global.Player["Player_Flags"]["Crate_R"] = true
		else:
			Global.Player["Player_Flags"]["Crate_R"] = false
		Global.Player["Player_Info"]["Object_Interact"] = chest_name
		Global.Player["Player_Flags"]["Can_OpenChest"] = true

func _on_Area2D_body_exited(body):

	if body.name == "Adventurer":
		Global.Player["Player_Flags"]["Can_OpenChest"] = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Chest_Open":
		$AnimationPlayer.play("Chest_Opened")
		_on_chest_opened()
