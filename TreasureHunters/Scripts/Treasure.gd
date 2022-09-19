extends StaticBody2D

var STATE = "Closed"

var chest_name
var chest_idx

func _ready():
	
	self.add_to_group("Chests")

	chest_name = self.name
	chest_idx = int(chest_name.replace("Chest","")) - 1


func _process(delta):
	if Global.STATE_PLAYER == "Chest_Opening" and STATE == "Closed" and Global.Player["Player_Info"]["Object_Interact"] == chest_name:
		STATE = "Opening"
		$AnimationPlayer.play("Chest_Open")
	elif STATE == "Opened":
		$AnimationPlayer.play("Chest_Opened")
	elif STATE == "Closed":
		$AnimationPlayer.play("Chest_Closed")

func _on_chest_opened():
	
	register_chest()
	Global.audio_players["TreasureCollection"].play(0)

func register_chest():
	
	Global.coins_total += 10
	Global.coins_collected_total += 10
	Global.coins_collected_level += 10
	Global.chests[chest_idx] = false
	
func _on_Area2D_body_entered(body):
	
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
