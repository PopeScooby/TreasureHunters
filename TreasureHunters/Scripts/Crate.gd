extends KinematicBody2D

const UP = Vector2(0,-1)

var gravity = 80
var acceleration = 200

var motion = Vector2()

var on_elevator = false
var in_water = false
var flow_dir = 1

func _ready():
	pass 

func _process(delta):
	
	
	motion.y += gravity
	
	var friction = false
	
#	if in_water == false:
	if Global.Player["Player_Flags"]["Can_Push"] == true and Input.is_action_pressed("action_interact"):
		
		if Input.is_action_pressed("move_right") and GlobalDictionaries.player_info["Object_Interact"] == self.name:
			motion.x = min(motion.x+acceleration, GlobalDictionaries.player_info["SpeedMax"])
		elif Input.is_action_pressed("move_left") and GlobalDictionaries.player_info["Object_Interact"] == self.name:
			motion.x = max(motion.x-acceleration, -GlobalDictionaries.player_info["SpeedMax"])
		else:
			friction = true
			
		if is_on_floor():
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.2)
			
	else:
		motion.x = 0
		
#	else:
#		if flow_dir == 1:
#			motion.x = 150
##			motion.y = 80
#		elif flow_dir == -1:
#			motion.x = -150
##			motion.y = 80
	
#	if on_elevator == true:
#		motion.y = -800
#
	motion = move_and_slide(motion, UP)
	

func _on_PushArea2D_body_entered(body):
	
	if body.name == "Adventurer":
		if body.position.x > self.position.x:
			Global.Player["Player_Flags"]["Crate_R"] = true
		else:
			Global.Player["Player_Flags"]["Crate_R"] = false
		Global.Player["Player_Info"]["Object_Interact"] = self.name
		Global.STATE_PLAYER = "OnCrate"

func _on_PushArea2D_body_exited(body):
	if body.name == "Adventurer":
		Global.STATE_PLAYER = "OffCrate"
