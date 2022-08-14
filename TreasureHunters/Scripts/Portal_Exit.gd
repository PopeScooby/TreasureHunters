extends Area2D


func _ready():
	self.visible = false

func _process(delta):
#	check_state()
	exec_state()
	
func check_state():
	if GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]["Level_Timer"] <= 0:
		Global.STATE_LEVEL = "Timeout"
		
func exec_state():

	if Global.STATE_LEVEL == "Spawn_Portal_Exit":
		$AnimationPlayer.play("Portal_Spawn")
		Global.STATE_LEVEL = "Gameplay"
	elif Global.STATE_LEVEL == "Despawn_Portal_Exit":
		$AnimationPlayer.play("Portal_Close")
		Global.STATE_LEVEL = "Gameplay"
	elif Global.STATE_LEVEL == "Timeout":
		$AnimationPlayer.play("Portal_Close")
		Global.STATE_LEVEL = "Gameplay"

func _on_AnimationPlayer_animation_finished(anim_name):
	
	if anim_name == "Portal_Spawn":
		$AnimationPlayer.play("Portal_Idle")
	elif anim_name == "Portal_Close":
		self.visible = false
		if Global.Player["Level_Current"] == 0:
			get_tree().change_scene("res://Scenes/Interface/Menu_GameStart.tscn")
		elif Global.Player["Level_Current"] == Global.Player["Level_Max"] and Global.Player["Level_Current"] != (Global.Player["Levels"].size() - 1):
			Global.Player["Level_Max"] += 1
		Global.Level["Complete"] = true
		Global.Player["Levels"][str(Global.Player["Level_Current"])] = Global.Level
		GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])] = Global.Player
		Global.save_game()
		get_tree().change_scene("res://Scenes/Interface/Menu_LevelSelect.tscn")

func _on_Portal_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		Global.Player["Player_Flags"]["On_Exit"] = true


func _on_Portal_body_exited(body):
	if body.name == "Adventurer" and self.visible == true:
		Global.Player["Player_Flags"]["On_Exit"] = false
#
