extends Button


func _ready():
	pass 

func fill_label(LevelNum):
#
	var Level = Global.Player["Levels"][str(LevelNum)]
#
	self.text = "Level #" + str(LevelNum) + ": " + str(Level["Coins_Collected"]) + " of " + str(Level["Coins"].size()) + " Coins" 


