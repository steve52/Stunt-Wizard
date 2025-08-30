extends Area2D

func _on_body_entered(body):
	GameManager.enteredLandingZone()
	body.velocity.x = 0
	body.SpellsAvailable = false
