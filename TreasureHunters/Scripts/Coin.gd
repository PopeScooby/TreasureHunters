extends Area2D


func _ready():
	
	self.add_to_group("Coins")


func _on_Coin_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		register_coin()
		Global.audio_players["CoinCollection"].play(.2)
		queue_free()

func register_coin():
	
	Global.coins_total += 1
	Global.coins_collected_total += 1
	var coin_idx = int(self.name.right(4)) - 1
	Global.coins_collected_level += 1
	Global.coins[coin_idx] = false
	
	
