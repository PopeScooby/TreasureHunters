extends Area2D


func _ready():
	
	add_to_group("Coins")


func _on_Coin_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		register_coin()
		queue_free()

func register_coin():
	
	var player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
	
	player["Coins"] += 1
	player["Coins_Collected"] += 1
	var coin_idx = int(self.name.right(4)) - 1
	player["Levels"][str(player["Level_Current"])]["Coins_Collected"] += 1
	player["Levels"][str(player["Level_Current"])]["Coins"][coin_idx] = false
	
