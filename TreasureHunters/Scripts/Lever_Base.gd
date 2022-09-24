extends Area2D

export (NodePath) var Lever_Path

var Lever_Name


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Lever_Base_body_entered(body):
	if body.name == "Adventurer" and self.visible:
		Global.Player["Player_Flags"]["Near_LeverBase"] = true


func _on_Lever_Base_body_exited(body):
	if body.name == "Adventurer":
		Global.Player["Player_Flags"]["Near_LeverBase"] = false
