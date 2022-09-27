extends StaticBody2D

var STATE = "Closed"

var chest_name
var chest_idx
var coins_in_chest = 10

onready var gameplay_interface = get_parent().get_parent().get_node("GameplayInterface")

func _ready():
	
	self.add_to_group("Chests")

	chest_name = self.name
	chest_idx = int(chest_name.replace("Chest","")) - 1


func _process(delta):
	if Global.STATE_PLAYER == "Chest_Opening" and STATE == "Closed" and Global.Player["Player_Info"]["Object_Interact"] == chest_name:
		STATE = "Opening"
		$AnimationPlayer.play("Chest_Open")
	elif STATE == "Opened":
		$AnimationPlayer.play("Chest_Opened")
	elif STATE == "Closed":
		$AnimationPlayer.play("Chest_Closed")

func _on_chest_opened():
	Global.audio_players["TreasureCollection"].play(0)
	register_chest()
	
	for i in range(self.coins_in_chest):
		
		var collected_coin: Control = load("res://Scenes/Items/CollectedCoin.tscn").instance()
		
		var coin_sprite: AnimatedSprite = collected_coin.get_node("CoinSprite")
		var coin_origin = coin_sprite.get_transform().get_origin() * .5
		var origin: Vector2 = $Sprite.get_global_transform_with_canvas().get_origin() - coin_origin
		
		# Hack - This is just copied from the Coin sprite 
		collected_coin.rect_scale = Vector2(0.374, 0.374)
		collected_coin.rect_global_position = origin

		self.gameplay_interface.add_child(collected_coin)
		collected_coin.animate()
		
		yield(get_tree().create_timer(.05), "timeout")
	

func register_chest():
	
	Global.coins_total += self.coins_in_chest
	Global.coins_collected_total += self.coins_in_chest
	Global.coins_collected_level += self.coins_in_chest
	Global.chests[chest_idx] = false
	
func _on_Area2D_body_entered(body):
	
	if body.name == "Adventurer" and Global.Level["Chests"][chest_idx] == true:
		if body.position.x > self.position.x:
			Global.Player["Player_Flags"]["Crate_R"] = true
		else:
			Global.Player["Player_Flags"]["Crate_R"] = false
		Global.Player["Player_Info"]["Object_Interact"] = chest_name
		Global.Player["Player_Flags"]["Can_OpenChest"] = true

func _on_Area2D_body_exited(body):

	if body.name == "Adventurer":
		Global.Player["Player_Flags"]["Can_OpenChest"] = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Chest_Open":
		$AnimationPlayer.play("Chest_Opened")
		_on_chest_opened()
