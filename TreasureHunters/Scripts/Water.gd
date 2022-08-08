extends Area2D

export var flow_dir = 1
export var flow_speed = 150

func _ready():
	pass 


func _on_Water_body_entered(body):
	if body.name == "Adventurer":
		Global.STATE_PLAYER = "InWater"
	elif body.name.left(5) == "Crate":
		body.in_water = true
		body.flow_dir = flow_dir
		body.flow_speed = flow_speed

func _on_Water_body_exited(body):
	if body.name.left(5) == "Crate":
		body.in_water = false
