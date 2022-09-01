extends Node2D

export (NodePath) var mover_path
export var activate_anim_name = ""
export var deactivate_anim_name = ""
export var is_active = false

func _ready():
	if is_active == false:
		$AnimationPlayer.play("Not_Active")
	else:
		$AnimationPlayer.play("Is_Active")


func _process(delta):
	if Input.is_action_just_pressed("action_interact") and Global.Player["Player_Flags"]["Can_PullLever"] == true:
		if is_active == false:
			$AnimationPlayer.play("Activate")
		else:
			$AnimationPlayer.play("Deactivate")

func _on_Area2D_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		Global.Player["Player_Flags"]["Can_PullLever"] = true

func _on_Area2D_body_exited(body):
	if body.name == "Adventurer" and self.visible == true:
		Global.Player["Player_Flags"]["Can_PullLever"] = false

#		var mover = get_node(mover_path + "/AnimationPlayer")
#		mover.play("Activate")


func _on_AnimationPlayer_animation_finished(anim_name):
	
	var mover = get_node(mover_path)
	var anim_player = mover.get_node("AnimationPlayer")
	
	if anim_name == "Activate":
		is_active = true
		$AnimationPlayer.play("Is_Active")
		if activate_anim_name == "STOP":
			anim_player.playback_speed = 0
		else:
			anim_player.playback_speed = 1
			anim_player.play(activate_anim_name)
	elif anim_name == "Deactivate":
		is_active = false
		$AnimationPlayer.play("Not_Active")
		if deactivate_anim_name == "STOP":
			anim_player.playback_speed = 0
		else:
			anim_player.playback_speed = 1
			anim_player.play(deactivate_anim_name)
		

