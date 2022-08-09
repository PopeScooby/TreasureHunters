extends Node2D

export var anim_name = "Up_Down_50"

func _ready():
	$AnimationPlayer.play(anim_name)


#func _process(delta):
#
#	check_state()
#	exec_state()
#
