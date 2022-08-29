extends Node2D

export var anim_name = ""

func _ready():
	if anim_name != "":
		$AnimationPlayer.play(anim_name)


#func _process(delta):
#
#	check_state()
#	exec_state()
#
