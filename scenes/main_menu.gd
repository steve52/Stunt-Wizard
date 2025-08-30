extends CanvasLayer

func _on_start_pressed():
	GameManager.startGame()

func _on_exit_pressed():
	get_tree().quit() 
