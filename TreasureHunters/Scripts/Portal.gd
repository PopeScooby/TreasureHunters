extends Area2D

func _ready():
	self.visible = false

func _process(delta):
	if Global.STATE_LEVEL == "Spawn_Portal":
		$AnimationPlayer.play("Portal_Spawn")
		Global.STATE_LEVEL = "Portal_Spawning"
	elif Global.STATE_LEVEL == "Despawn_Portal":
		$AnimationPlayer.play("Portal_Close")
#		Global.STATE_LEVEL = "Gameplay"
		Global.STATE_LEVEL = "Spawn_Portal_Exit"
		
func _on_AnimationPlayer_animation_finished(anim_name):
	
	var player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	
	if anim_name == "Portal_Spawn":
		Global.STATE_LEVEL = "Spawn_Player"
		$AnimationPlayer.play("Portal_Idle")
	elif anim_name == "Portal_Close":
		self.visible = false
#		if player["Level_Current"] == 1 and player["Scene_Seen"]["Level1_Enter"] == false:
#			Global.STATE_LEVEL = "Play_Scene"
#			Global.STATE_PLAYER = "Play_Scene"
