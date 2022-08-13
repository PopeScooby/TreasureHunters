extends KinematicBody2D

var move_speed = 100
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
var velocity = Vector2.ZERO

func _ready():
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()

func _process(delta):
	if !patrol_path:
		return
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	velocity = (target - position).normalized() * move_speed
	velocity = move_and_slide(velocity)


func _on_Area2D_body_entered(body):

	if body.name == "Adventurer" and Global.Player["Hearts"] > 0:
		Global.Player["Player_Flags"]["On_Enemy"] = true
		$Timer_Damage.start()
	elif body.name == "Adventurer" and Global.Player["Hearts"] <= 0:
		$Timer_Damage.stop()

func _on_Area2D_body_exited(body):
	$Timer_Damage.stop()
	Global.Player["Player_Flags"]["On_Enemy"] = false


func _on_Timer_Damage_timeout():

	if Global.Player["Hearts"] > 0:
		Global.Player["Player_Flags"]["On_Enemy"] = true
		$Timer_Damage.start()
	else:
		$Timer_Damage.stop()

