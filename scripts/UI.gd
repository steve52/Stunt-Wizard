extends CanvasLayer

@onready var style = $Style
@onready var mana_points = $Mana/ManaPoints

func updateMana(newVal):
	mana_points.text = str(newVal)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
