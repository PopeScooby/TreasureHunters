extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var target_pos: Vector2
var duration = .6
onready var tween = get_node("Tween")

func _ready():
	var coin_ui: TextureRect = get_parent().get_parent().get_node("GameplayInterface/Coin/CoinImage")
	self.target_pos = coin_ui.rect_global_position
	
	
func animate():
	self.tween.interpolate_property(self, "rect_global_position", self.rect_global_position, self.target_pos, self.duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	self.tween.start()
	self.tween.interpolate_callback(self, self.duration, "queue_free")
	
func _physics_process(delta):
	print(self.rect_global_position)
