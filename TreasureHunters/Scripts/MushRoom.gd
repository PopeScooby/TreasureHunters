extends Control

export var curr_scene = ""

var selector_curr = 1
var selector_locations = {1:{"Position":Vector2(271,453),
							 "Size":Vector2(153,75)}, 
						  2:{"Position":Vector2(100,267),
							 "Size":Vector2(193,163)}, 
						  3:{"Position":Vector2(411.25,267),
							 "Size":Vector2(193,163)}}

func _ready():
	pass

func _process(delta):
	

	if Global.items["Jumpshroom1"] and $SidePanel.visible == true:
		$SidePanel/Jumpshroom1.visible = false
	else:
		$SidePanel/Jumpshroom1.visible = true
		
	if Global.items["Jumpshroom2"] and $SidePanel.visible == true:
		$SidePanel/Jumpshroom2.visible = false
	else:
		$SidePanel/Jumpshroom2.visible = true
		
	
	if Global.STATE_LEVEL == "InMushRoom" and curr_scene != "" and self.visible == true and $ContinueLabel.visible == false and $SidePanel.visible == false:
		$AnimationPlayer.play(curr_scene)
	elif Input.is_action_just_pressed("menu_select") and $ContinueLabel.visible == true:
		$SpeechBubble.visible = false
		$ContinueLabel.visible = false
		$SidePanel.visible = true
	elif Input.is_action_just_pressed("menu_select") and $SidePanel.visible == true:
		if selector_curr == 1:
			exit_mush_room()
		elif selector_curr == 2:
			buy_jumshroom_1()
		elif selector_curr == 3:
			buy_jumshroom_2()

	elif Input.is_action_just_pressed("menu_up") and $SidePanel.visible == true and selector_curr == 1:
		selector_curr = 2
		self.move_selector()
	elif Input.is_action_just_pressed("menu_down") and $SidePanel.visible == true and (selector_curr == 2 or selector_curr == 3):
		selector_curr = 1
		self.move_selector()
	elif Input.is_action_just_pressed("menu_right") and $SidePanel.visible == true and (selector_curr == 2 or selector_curr == 1):
		selector_curr = 3
		self.move_selector()
	elif Input.is_action_just_pressed("menu_left") and $SidePanel.visible == true and (selector_curr == 3 or selector_curr == 1):
		selector_curr = 2
		self.move_selector()
	


func move_selector():
	$SidePanel/Selector.rect_position = selector_locations[selector_curr]["Position"]
	$SidePanel/Selector.rect_size = selector_locations[selector_curr]["Size"]

func buy_jumshroom_1():
	if Global.coins_total >= 75 and Global.items["Jumpshroom1"]["InInventory"] == false:
		Global.coins_total -= 75
		Global.items["Jumpshroom1"]["InInventory"] = true
	
	

func buy_jumshroom_2():
	if Global.coins_total >= 75 and Global.items["Jumpshroom2"]["InInventory"] == false:
		Global.coins_total -= 75
		Global.items["Jumpshroom2"]["InInventory"] = true


func exit_mush_room():
	Global.STATE_LEVEL = "ExitMushRoom"

