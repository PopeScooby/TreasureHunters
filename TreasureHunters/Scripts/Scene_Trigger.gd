extends Area2D

export var scene_num = 0

func _ready():
	pass 
	
func _process(delta):
	pass


func _on_Scene_Trigger_body_entered(body):
	if body.name == "Adventurer":
		Global.STATE_LEVEL = "Play_Scene"
		Global.STATE_PLAYER = "Scene_Level1_2"

func _on_Scene_Trigger_body_exited(body):
	pass # Replace with function body.
