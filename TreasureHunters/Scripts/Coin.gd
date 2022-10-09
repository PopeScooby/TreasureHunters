extends Area2D


onready var gameplay_interface = get_parent().get_parent().get_node("GameplayInterface")

func _ready():
	self.add_to_group("Coins")


func _on_Coin_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		Global.audio_players["CoinCollection"].play()
		
		var coin_idx = int(self.name.right(4)) - 1
		GlobalDictionaries.current_data["Coins"][coin_idx] = false
		
		self.visible = false
		
		var collected_coin: Control = load("res://Scenes/Items/CollectedCoin.tscn").instance()
		collected_coin.rect_global_position = self.get_global_transform_with_canvas().get_origin()
		collected_coin.rect_scale = $Sprite.transform.get_scale()
		
		collected_coin.connect("tree_exiting", self, "_register_coin_and_exit")

		self.gameplay_interface.add_child(collected_coin)
		collected_coin.animate()
		

func _register_coin_and_exit():
	Global.coins_total += 1
	Global.coins_collected_total += 1
	Global.coins_collected_level += 1
	
	queue_free()
	
	
	
