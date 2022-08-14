extends Button


func _ready():
	pass 

func fill_label(PlayerKey):
	
	Global.Player = GlobalDictionaries.players[str(PlayerKey)]
	
	self.text = str(PlayerKey) + ". " + Global.Player["Name"] + " - Treasures: " +  str(Global.Player["Level_Max"] - 1) + "; Coins: " + str(Global.Player["Coins"]) + "; Hearts: " + str(Global.Player["Hearts"])
