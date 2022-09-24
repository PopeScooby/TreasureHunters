extends Area2D

export (NodePath) var Lever_Path

var Lever_Name


func _ready():
	Lever_Name = self.name


func _process(delta):
	if Input.is_action_just_pressed("action_interact") and Global.Player["Player_Flags"]["Near_LeverBase"] == true and Global.Player["Current_Item"] == "Handle" and Global.Player["Player_Info"]["Object_Interact"] == self.name and self.visible:
		var Complete_Lever = get_node(Lever_Path)
		Complete_Lever.visible = true
		self.visible = false


func _on_Lever_Base_body_entered(body):
	if body.name == "Adventurer" and self.visible:
		Global.Player["Player_Info"]["Object_Interact"] = Lever_Name
		Global.Player["Player_Flags"]["Near_LeverBase"] = true


func _on_Lever_Base_body_exited(body):
	if body.name == "Adventurer":
		Global.Player["Player_Info"]["Object_Interact"] = Lever_Name
		Global.Player["Player_Flags"]["Near_LeverBase"] = false
