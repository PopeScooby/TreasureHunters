extends Area2D


onready var gameplay_interface = get_parent().get_parent().get_node("GameplayInterface")

func _ready():
	self.add_to_group("Coins")


func _on_Coin_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		Global.audio_players["CoinCollection"].play()
		
		var collected_coin: Control = load("res://Scenes/Items/CollectedCoin.tscn").instance()
		collected_coin.rect_global_position = self.get_global_transform_with_canvas().get_origin()
		collected_coin.rect_scale = $Sprite.transform.get_scale()

		self.gameplay_interface.add_child(collected_coin)
		
		collected_coin.animate()
		register_coin()
		queue_free()

func register_coin():
	
	Global.coins_total += 1
	Global.coins_collected_total += 1
	var coin_idx = int(self.name.right(4)) - 1
	Global.coins_collected_level += 1
	Global.coins[coin_idx] = false
	
