extends CanvasLayer

var heart = load("res://Textures/Items/Heart.png")
var heart_container = load("res://Textures/Items/Heart_Empty.png")

func _ready():
	pass

func _on_LevelTimeTimer_timeout():
	
	$Timer/LevelTimeTimer.start()
	Global.Player["Level_Timer"] -= 1

func _process(delta):

	$Timer/LevelTimeLbl.text = str(Global.Player["Level_Timer"])
	if Global.Player["Level_Timer"] == 0:
		get_tree().paused = true
	$Coin/Coin_Count_Label.text = str(Global.Player["Coins"])
	
	if Global.Player["Hearts_Total"] < 5:
		$Hearts/Heart5.visible = false
	if Global.Player["Hearts_Total"] < 4:
		$Hearts/Heart4.visible = false
	if Global.Player["Hearts_Total"] < 3:
		$Hearts/Heart3.visible = false
	if Global.Player["Hearts_Total"] < 2:
		$Hearts/Heart2.visible = false
	if Global.Player["Hearts_Total"] < 1:
		$Hearts/Heart1.visible = false
#
	for x in 6:
		if x != 0:
			var HeartNode = get_node("Hearts/Heart" + str(x))

			if Global.Player["Hearts_Total"] < x:
				HeartNode.visible = false

			if Global.Player["Hearts"] < x:
				HeartNode.texture = heart_container
			else:
				HeartNode.texture = heart

	


