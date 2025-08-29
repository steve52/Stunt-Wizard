extends Area2D




func _on_body_entered(body):
	body.EnterPortal()
	self.queue_free()


func _on_dodge_area_body_entered(body):
	body.PortalDodge()
	self.queue_free()

