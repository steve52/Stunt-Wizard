extends CanvasLayer

@onready var style = $Style
@onready var mana_points = $Mana/ManaPoints
@onready var retry = $Retry
@onready var level_complete_msg = $LevelCompleteMsg
@onready var level_failed_msg = $LevelFailedMsg

func updateMana(newVal):
	mana_points.text = str(newVal)

func _ready():
	level_complete_msg.visible = false
	level_failed_msg.visible = false
	retry.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GameManager.isLevelFinished()):
		retry.visible = true
		if (GameManager.isPlayerAlive()):
			level_complete_msg.visible = true
		else:
			level_failed_msg.visible = true

func _on_retry_pressed():
	GameManager.retryLevel()
	
