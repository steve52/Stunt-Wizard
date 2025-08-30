extends Area2D


func _on_body_entered(body):
	body.HitFlamingRing()
	queue_free()




func _on_ring_center_body_entered(body):
	await get_tree().create_timer(.25) 
	body.WentThroughFlamingRing()
	self.queue_free()





func _on_outside_ring_body_entered(body):
	body.DodgedFlamingRing()
	self.queue_free()
