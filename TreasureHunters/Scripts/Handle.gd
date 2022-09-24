extends Area2D

var Handle_Name 


func _ready():
	Handle_Name = self.name
	
	if Global.items[Handle_Name]["InInventory"] or Global.items[Handle_Name]["Level"] != 0:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Handle_body_entered(body):
	if body.name == "Adventurer":
		Global.items["Handle1"]["InInventory"] = true
		if not GlobalDictionaries.items.has("Handle"):
			GlobalDictionaries.items.append("Handle")
		queue_free()
