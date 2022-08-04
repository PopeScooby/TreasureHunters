extends CanvasLayer

var player

func _ready():
	pass

func _on_LevelTimeTimer_timeout():
	
	player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	
	$Timer/LevelTimeTimer.start()
	player["Level_Timer"] -= 1

func _process(delta):
	
	player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	
	$Timer/LevelTimeLbl.text = str(player["Level_Timer"])
	$Coin/Coin_Count_Label.text = str(player["Coins"])
	
#	$Coin_Amount_Label.text = str(Player["Coins"])
#
##	if Player["Hearts_Total"] < 5:
##		$Hearts/Heart5.visible = false
##	if Player["Hearts_Total"] < 4:
##		$Hearts/Heart4.visible = false
##	if Player["Hearts_Total"] < 3:
##		$Hearts/Heart3.visible = false
##	if Player["Hearts_Total"] < 2:
##		$Hearts/Heart2.visible = false
##	if Player["Hearts_Total"] < 1:
##		$Hearts/Heart1.visible = false
#
#	for x in 6:
#		if x != 0:
#			var HeartNode = get_node("Hearts/Heart" + str(x))
#
#			if Player["Hearts_Total"] < x:
#				HeartNode.visible = false
#
#			if Player["Hearts"] < x:
#				HeartNode.texture = heart_container
#			else:
#				HeartNode.texture = heart
#


