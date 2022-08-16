extends CanvasLayer

var heart = load("res://Textures/Items/Heart.png")
var heart_container = load("res://Textures/Items/Heart_Empty.png")

var selector_curr = 1
var selector_locations = {1:270, 2:330, 3:400}

func _ready():
	$PauseScreen.visible = false

func _on_LevelTimeTimer_timeout():
	
	$Timer/LevelTimeTimer.start()
	Global.Player["Level_Timer"] -= 1

func _process(delta):
	
	$Timer/LevelTimeLbl.text = str(Global.Player["Level_Timer"])
	if Global.Player["Level_Timer"] == 0:
		get_tree().paused = true		
	if Input.is_action_just_pressed("pause") and get_tree().paused == true:
		exec_state_unpause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == false:
		exec_state_pause()
	elif $PauseScreen.visible == true:
		exec_state_menu()
		
		
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

func exec_state_pause():
	get_tree().paused = true
	$Timer/LevelTimeTimer.stop()
	$PauseScreen.visible = true

func exec_state_unpause():
	get_tree().paused = false
	$Timer/LevelTimeTimer.start()
	$PauseScreen.visible = false

func exec_state_menu():
	if Input.is_action_just_pressed("menu_down") and selector_curr != 0:
		if selector_curr != 3:
			selector_curr += 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_up") and selector_curr != 0:
		if selector_curr != 1:
			selector_curr -= 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_select"):
		if selector_curr == 1:
			exec_state_unpause()
			Global.load_level()
		elif selector_curr == 2:
			exec_state_unpause()
			get_tree().change_scene("res://Scenes/Interface/Menu_LevelSelect.tscn")
		elif selector_curr == 3:
			get_tree().quit()
	
	elif Input.is_action_just_pressed("menu_back"):
		exec_state_unpause()

func _move_selector():
	$PauseScreen/Selector.rect_position.y = selector_locations[selector_curr]



